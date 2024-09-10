part of 'card_box_info_bloc.dart';

enum CardBoxInfoLoadStatus {
  loading,
  ready,
  error,
}

class CardBoxInfoState {
  CardBox? cardBox;
  CardBoxInfoLoadStatus status;
  String? errorMsg;
  bool changed;
  CardBoxInfoState({
    this.status = CardBoxInfoLoadStatus.loading,
    this.cardBox,
    this.errorMsg = "",
    this.changed = false,
  });
  CardBoxInfoState copyWith(
      {CardBox? cardBox,
      CardBoxInfoLoadStatus? status,
      String? errorMsg,
      bool? changed}) {
    return CardBoxInfoState(
      cardBox: cardBox ?? this.cardBox,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      changed: changed ?? this.changed,
    );
  }
}
