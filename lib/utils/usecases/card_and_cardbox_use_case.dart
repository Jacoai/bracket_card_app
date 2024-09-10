import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:injectable/injectable.dart';

@injectable
class CardandCardBoxUseCase {
  CardandCardBoxUseCase(
    @injectable this._dataProviderRepository,
  );
  late final CardandCardBoxRepository _dataProviderRepository;

  List<CardBox> getFavoritesCardBoxes() {
    return _dataProviderRepository.favoritesBoxes.value;
  }

   int? findCardBoxInDb(CardBox cardBox) {
    return _dataProviderRepository.findCardBoxInDb(cardBox);
  }

  Future<void> init() async {
    try {
      await _dataProviderRepository.init();
    } catch (error) {
      throw RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> addCardBox(CardBox cardBox) async {
    return await _dataProviderRepository.addCardBox(cardBox);
  }

  Future<RequestMessage> addBoxToFavorite(CardBox cardBox) async {
    return await _dataProviderRepository.addBoxToFavorite(cardBox);
  }

  Future<List<CardBox>> getAllFavoritesCardBoxes(
    String username, {
    int start = 0,
  }) async {
    return await _dataProviderRepository.getAllFavoritesCardBoxes(
      username,
      start: start,
    );
  }

  Future<RequestMessage> deleteFromFavorite(CardBox cardBox) async {
    return await _dataProviderRepository.deleteBoxFromFavorites(cardBox);
  }

  Future<void> initCardsDb(CardBox cardBox) async {
    try {
      await _dataProviderRepository.initCardDb(cardBox);
    } catch (error) {
      throw RequestMessage(message: error.toString());
    }
  }

  Future<RequestMessage> deleteCardBox(CardBox cardBox) async {
    return await _dataProviderRepository.deleteCardBox(cardBox);
  }

  Future<RequestMessage> updateCardBox(CardBox cardBox) async {
    return await _dataProviderRepository.updateCardBox(cardBox);
  }

  Future<List<CardBox>> getAllCardBoxes(
    String username, {
    int start = 0,
  }) async {
    return await _dataProviderRepository.getAllCardBoxes(
      username,
      start: start,
    );
  }

  Future<List<CardBox>> findBoxes(
    String tag,
    String question, {
    String start = '0',
  }) async {
    return await _dataProviderRepository.findBoxes(
      tag,
      question,
      start: start,
    );
  }

  Future<RequestMessage> addCard(LearningCard card, CardBox cardBox) async {
    return await _dataProviderRepository.addCard(
      card,
      cardBox,
    );
  }

  Future<RequestMessage> deleteCard(LearningCard card) async {
    return await _dataProviderRepository.deleteCard(card);
  }

  Future<RequestMessage> updateCard(LearningCard card) async {
    return await _dataProviderRepository.updateCard(
      card,
    );
  }

  Future<List<LearningCard>> showAllCardsFromBoxInDb(CardBox box) async {
    return await _dataProviderRepository.showAllCardsFromBoxinDb(box);
  }

  Future<List<LearningCard>> showAllCardsFromBoxFromServer(CardBox box) async {
    return await _dataProviderRepository.showAllCardsFromBoxFromServer(box);
  }

  Future<String?> getAvatar(String nickname) async {
    try {
      return await _dataProviderRepository.getAvatar(nickname);
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
      await _dataProviderRepository.deleteAvatar();
      await _dataProviderRepository.setAvatar(path, nickname);
    } catch (error) {
      if (error is ManagingException) {
        print(error.statusCode);
      }
      print(error);
    }
  }
}
