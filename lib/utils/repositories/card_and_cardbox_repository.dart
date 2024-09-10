import 'package:bracket_card_app/utils/models/user_avatar.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:client_database/remote_providers/managing_remote_data_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
class CardandCardBoxRepository with ChangeNotifier {
  late ManagingRemoteDataProvider _dataProvider;
  late Dio _dio;
  //final ValueNotifier<List<CardBox>> listCardBox = ValueNotifier([]);
  ValueNotifier<UserAvatar?> userAvatar = ValueNotifier(null);
  late CardBoxDao _cardBoxDao;
  late CardsDao _cardsDao;
  late User? _user;
  final ValueNotifier<List<CardBox>> favoritesBoxes =
      ValueNotifier(List.empty(growable: true));

  Future<void> init() async {
    try {
      _dio = GetIt.instance<AuthorizationRepository>().dio;
      _user = GetIt.instance<AuthorizationRepository>().activeUser.value;
      if (_user == null) throw Exception('Ошибка инициализаци DataProvider');
      _dataProvider = ManagingRemoteDataProvider(_user!, _dio);
      _cardBoxDao = CardBoxDao(await Hive.openBox<CardBox>('cB${_user!.name}'));
      await getAvatar(_user!.name);
      try {
        await _dataProvider.getState();
      } catch (error) {
        await _dataProvider.setState(UserState([]));
      }
      await synchronization();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> initCardDb(CardBox cardBox) async {
    _cardsDao =
        CardsDao(await Hive.openBox<LearningCard>('lc${_user!.name}'), cardBox);
  }

  Future<void> removeCardsFromBd(CardBox cardBox) async {
    await initCardDb(cardBox);
    final listCards = await _cardsDao.showAllCards();
    for (var card in listCards) {
      _cardsDao.deleteCard(card);
    }
    await _cardBoxDao.updateCardBox(cardBox.copyWith(cardIds: []));

    final list = await _cardsDao.showAllCards();
    print('___________________');
    print(list);
  }

  Future<void> downoloadCardsToBd(CardBox cardBox) async {
    await initCardDb(cardBox);
    final list = await _cardsDao.showAllCards();
    print('КАРТОЧКИ ПРИ ЗАГРУЗКЕ___________________');
    print(list);
    print(cardBox.id);
    final listCards = await _dataProvider.getAllCardsFromBox(cardBox.id);
    print(listCards.length);
    for (var card in listCards) {
      await _cardsDao.addCardWithoutCheck(card);
      print('добавляем карточку ');
    }
  }

  Future<RequestMessage> addBoxToFavorite(CardBox cardBox) async {
    try {
      await _dataProvider.addBoxToFavorites(cardBox.id);
      await _cardBoxDao.addCardBox(cardBox); //сохраняем бокс
      await downoloadCardsToBd(cardBox); //сохраняем карточки
      favoritesBoxes.value = (favoritesBoxes.value..add(cardBox)).toList();
      final userState = await _dataProvider.getState();

      userState.boxStates.add(
        await _getBoxState(cardBox),
      );

      await _dataProvider.setState(userState);

      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> deleteBoxFromFavorites(CardBox cardBox) async {
    try {
      await removeCardsFromBd(cardBox);
      await _dataProvider.deleteBoxFromFavorites(cardBox.id);
      await _cardBoxDao.deleteCardBox(cardBox);
      favoritesBoxes.value = List.from(favoritesBoxes.value..remove(cardBox));
      favoritesBoxes.notifyListeners();

      final userState = await _dataProvider.getState();

      final index = userState.boxStates
          .indexWhere((element) => element.boxId == cardBox.id);

      userState.boxStates.removeAt(index);

      await _dataProvider.setState(userState);

      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<List<CardBox>> getAllFavoritesCardBoxes(
    String username, {
    int start = 0,
  }) async {
    try {
      favoritesBoxes.value = (await _cardBoxDao.showAllCardBoxes())
          .where((element) => element.author != _user!.name)
          .toList();
      favoritesBoxes.notifyListeners();
      return favoritesBoxes.value;
    } catch (error) {
      if (error is ManagingException) {
        throw RequestMessage(code: error.statusCode);
      } else {
        throw RequestMessage(message: error.toString());
      }
    }
  }

  Future<RequestMessage> addCardBox(CardBox cardBox) async {
    try {
      await _dataProvider.addBox(cardBox);
      await _cardBoxDao
          .addCardBox(cardBox.copyWith(dateUpdate: DateTime.now()));

      final userState = await _dataProvider.getState();
      userState.boxStates.add(
        BoxState(cardBox.id, []),
      );
      await _dataProvider.setState(userState);

      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> deleteCardBox(CardBox cardBox) async {
    try {
      await removeCardsFromBd(cardBox);
      await _cardBoxDao.deleteCardBox(cardBox);
      await _dataProvider.deleteBox(cardBox.id);

      final userState = await _dataProvider.getState();

      final index = userState.boxStates
          .indexWhere((element) => element.boxId == cardBox.id);

      userState.boxStates.removeAt(index);

      await _dataProvider.setState(userState);

      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> updateCardBox(CardBox cardBox) async {
    try {
      await _dataProvider.updateBox(cardBox);
      await _cardBoxDao.updateCardBox(cardBox);

      final userState = await _dataProvider.getState();
      final index = userState.boxStates
          .indexWhere((element) => element.boxId == cardBox.id);

      userState.boxStates.removeAt(index);
      userState.boxStates.insert(index, await _getBoxState(cardBox));

      await _dataProvider.setState(userState);
      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<BoxState> _getBoxState(CardBox cardBox) async {
    await initCardDb(cardBox);
    List<CardState> states = [];
    final cards = await _cardsDao.showAllCards();
    for (var card in cards) {
      states.add(CardState(
        card.id!,
        card.isSolved,
        card.showTime ?? DateTime.now(),
        card.dateUpdate ?? DateTime.now(),
      ));
    }
    return BoxState(cardBox.id, states);
  }

  int? findCardBoxInDb(CardBox cardBox) {
    return _cardBoxDao.findCardBox(cardBox);
  }

  Future<List<CardBox>> findBoxes(
    String tag,
    String question, {
    String start = '0',
  }) async {
    try {
      return await _dataProvider.findBoxes(
        tag,
        question,
        start,
      );
    } catch (error) {
      if (error is ManagingException) {
        throw RequestMessage(code: error.statusCode);
      } else {
        throw RequestMessage(message: error.toString());
      }
    }
  }

  Future<List<CardBox>> getAllCardBoxes(
    String username, {
    int start = 0,
  }) async {
    try {
      final onlyMyCardBoxes = (await _cardBoxDao.showAllCardBoxes())
          .where(
            (element) => element.author == _user!.name,
          )
          .toList();

      return onlyMyCardBoxes;
    } catch (error) {
      if (error is ManagingException) {
        throw RequestMessage(code: error.statusCode);
      } else {
        throw RequestMessage(message: error.toString());
      }
    }
  }

  Future<RequestMessage> addCard(LearningCard card, CardBox cardBox) async {
    try {
      await initCardDb(cardBox);

      await _dataProvider.addCard(
        card,
        cardBox.id,
      );
      await _cardsDao.addCard(card.copyWith(dateUpdate: DateTime.now()));

      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> deleteCard(LearningCard card) async {
    try {
      await _dataProvider.deleteCard(card.id!);
      await _cardsDao.deleteCard(card);
      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }

      return RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> updateCard(LearningCard card) async {
    try {
      await _dataProvider.updateCard(
        card,
      );
      await _cardsDao.updateCard(card.copyWith(
        dateUpdate: DateTime.now(),
        showTime: card.showTime ?? DateTime.now(),
      ));

      return const RequestMessage();
    } catch (error) {
      if (error is ManagingException) {
        return RequestMessage(code: error.statusCode);
      }
      return RequestMessage(message: error.toString());
    }
  }

  Future<List<LearningCard>> showAllCardsFromBoxinDb(CardBox box) async {
    try {
      await initCardDb(box);
      return await _cardsDao.showAllCards();
    } catch (error) {
      print(error);
      if (error is ManagingException) {
        throw RequestMessage(code: error.statusCode);
      }
      throw RequestMessage(message: error.toString());
    }
  }

  Future<List<LearningCard>> showAllCardsFromBoxFromServer(CardBox box) async {
    try {
      return await _dataProvider.getAllCardsFromBox(box.id);
    } catch (error) {
      print(error);
      if (error is ManagingException) {
        throw RequestMessage(code: error.statusCode);
      }
      if (error is DioException) {
        throw RequestMessage(message: error.message!);
      }
      throw RequestMessage(message: error.toString());
    }
  }

  Future<int> getNumberOfLearnedCard(CardBox box) async {
    await initCardDb(box);
    return await _cardsDao.findNumStudiedCards();
  }

  Future<void> synchronization() async {
    final Box<LearningCard> box = await Hive.openBox('lc${_user!.name}');
    final list = await _dataProvider.updateCardBox(_cardBoxDao, box);
    for (String cardBox in list) {
      print(cardBox);
    }
  }

  Future<String?> getAvatar(String nickname) async {
    try {
      final String path = await _dataProvider.getAvatar(nickname);
      userAvatar.value = UserAvatar(
        path: path,
      );
      return path;
    } catch (error) {
      if (error is ManagingException) {
        print(error.statusCode);
      }
      print(error);
      return null;
    }
  }

  Future<void> setAvatar(String path, String nickname) async {
    try {
      await _dataProvider.setAvatar(path);
    } catch (error) {
      if (error is ManagingException) {
        print(error.statusCode);
      }
      print(error);
    }
  }

  Future<void> deleteAvatar() async {
    try {
      await _dataProvider.deleteAvatar();
    } catch (error) {
      if (error is ManagingException) {
        print(error.statusCode);
      }
      print(error);
    }
  }
}

class RequestMessage {
  final int code;
  final String message;

  const RequestMessage({
    this.code = 200,
    this.message = "",
  });
  String getMessage() {
    switch (code) {
      case 400:
        {
          return SLocale.current.invailidData;
        }
      case 403:
        {
          return SLocale.current.notExist;
        }
      case 500:
        return '${SLocale.current.globalError}\n$message';
    }
    return message;
  }
}
