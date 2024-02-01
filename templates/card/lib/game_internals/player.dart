import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'playing_card.dart';

class Player extends ChangeNotifier {
  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges => StreamGroup.mergeBroadcast([handCardChanges]);

  final StreamController<void> _handCardChanges =
      StreamController<void>.broadcast();

  Stream<void> get handCardChanges => _handCardChanges.stream;

  void broadcastHandCardChanges() {
    _handCardChanges.add(null);
  }

  /// 選擇卡片進行狀態
  PickCardProgressStatus pickCardProgressStatus =
      PickCardProgressStatus.startPicking;

  /// 被翻開的第一張卡
  PlayingCard? firstCardRevealed;

  /// 被翻開的第二張卡
  PlayingCard? secondCardRevealed;

  /// 開始選擇卡片
  void initialStartPicking() {
    pickCardProgressStatus = PickCardProgressStatus.startPicking;
    firstCardRevealed = null;
    secondCardRevealed = null;
    notifyListeners();
  }

  Future<void> clickCard({
    required PlayingCard card,
  }) async {
    debugPrint('clickCard');
    debugPrint('${card.value}');
    debugPrint(card.suit.backImagePath(card.value));

    if (card.isPairingCompleted) {
      debugPrint('isPairingCompleted');
      return;
    }
    debugPrint('before pickCardProgressStatus: $pickCardProgressStatus');

    switch (pickCardProgressStatus) {
      case PickCardProgressStatus.startPicking:
        card.isFront = !card.isFront;

        if (card.isFront == false) {
          firstCardRevealed = card;
          pickCardProgressStatus = PickCardProgressStatus.turnOverTheFirstCard;
        } else {
          pickCardProgressStatus = PickCardProgressStatus.startPicking;
        }
        break;
      case PickCardProgressStatus.turnOverTheFirstCard:

        ///須重新命名
        card.isFront = !card.isFront;
        secondCardRevealed = null;

        if (card.isFront == false) {
          secondCardRevealed = card;

          ///是否通過
          bool isPassOrNot = true;
          isPassOrNot = isPassOrNot && (firstCardRevealed != null);
          isPassOrNot = isPassOrNot && (secondCardRevealed != null);
          isPassOrNot = isPassOrNot &&
              (firstCardRevealed.hashCode != secondCardRevealed.hashCode);

          ///檢查卡片的圖片是否相同
          if (isPassOrNot) {
            firstCardRevealed!.clearState();
            secondCardRevealed!.clearState();

            //卡片們是相同
            bool isTheSame = true;
            isTheSame = isTheSame &&
                firstCardRevealed!.suit == secondCardRevealed!.suit;
            isTheSame = isTheSame &&
                firstCardRevealed!.value == secondCardRevealed!.value;

            if (isTheSame) {
              debugPrint('isTheSame');
              firstCardRevealed!.paired();
              secondCardRevealed!.pairedAsRepresentative();

              pickCardProgressStatus = PickCardProgressStatus.pairingSuccessful;
            } else {
              debugPrint('isTheDifferent');
              pickCardProgressStatus = PickCardProgressStatus.pairingFailed;
            }

            notifyListeners();

            await Future.delayed(Duration(milliseconds: 800)).then((value) {
              debugPrint('cards Status');
              firstCardRevealed!.isFront = true;
              secondCardRevealed!.isFront = true;
              notifyListeners();
            });

            initialStartPicking();
          } else {
            debugPrint('some problem');
            debugPrint('maybe clicked the same card');
          }
          return;
        } else {
          pickCardProgressStatus = PickCardProgressStatus.startPicking;
        }
        break;
      default:
    }

    debugPrint('after pickCardProgressStatus: $pickCardProgressStatus');
    notifyListeners();
  }

  /// 使壞計數
  bool isGood = true;

  void notifyChange() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _handCardChanges.close();
  }
}

///選擇卡片進行狀態
enum PickCardProgressStatus {
  startPicking, //開始選擇卡片
  turnOverTheFirstCard, //翻開第一張卡
  pairingSuccessful, //配對成功
  pickingAgain, //再次選擇卡片
  pairingFailed, //配對失敗
  end, //結束
  ;
}
