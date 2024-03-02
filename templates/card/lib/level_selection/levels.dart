// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../game_internals/card_suit.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<GameLevel> gameLevels0 = [
  GameLevel(
    number: 1,
    maxCards: 16,
    cardSuits: [
      CardSuit(TrashType.electronicAppliances),
      CardSuit(TrashType.itEquipment),
      CardSuit(TrashType.dryCellBatteries),
      CardSuit(TrashType.vcdOrDvd),
    ],
  ),
  GameLevel(
    number: 2,
    maxCards: 4,
    cardSuits: [
      CardSuit(TrashType.kitchenWasteAsPigFood),
      CardSuit(TrashType.kitchenWasteAsCompost),
    ],
  ),
];

List<GameLevel> gameLevels = [
  ///一般垃圾、可回收垃圾
  GameLevel(
    number: 1,
    maxCards: 12,
    cardSuits: [
      CardSuit(TrashType.trash),
      CardSuit(TrashType.recyclableTrash),
    ],
  ),

  ///養豬廚餘、堆肥廚餘
  GameLevel(
    number: 2,
    maxCards: 12,
    cardSuits: [
      CardSuit(TrashType.kitchenWasteAsPigFood),
      CardSuit(TrashType.kitchenWasteAsCompost),
    ],
  ),

  ///紙容器、紙類、紙類垃圾
  GameLevel(
    number: 3,
    maxCards: 12,
    cardSuits: [
      CardSuit(TrashType.paperContainers),
      CardSuit(TrashType.paper),
      CardSuit(TrashType.trashPaper),
    ],
  ),

  ///塑膠容器、乾淨發泡塑膠、乾淨塑膠袋
  GameLevel(
    number: 4,
    maxCards: 12,
    cardSuits: [
      CardSuit(TrashType.plasticBottles),
      CardSuit(TrashType.styrofoam),
      CardSuit(TrashType.cleanPlasticBags),
    ],
  ),

  ///塑膠容器、玻璃容器、金屬容器
  GameLevel(
    number: 5,
    maxCards: 12,
    cardSuits: [
      CardSuit(TrashType.plasticBottles),
      CardSuit(TrashType.glassContainers),
      CardSuit(TrashType.metalContainers),
    ],
  ),

  ///電子電器、資訊物品、乾電池、光碟片
  GameLevel(
    number: 6,
    maxCards: 16,
    cardSuits: [
      CardSuit(TrashType.electronicAppliances),
      CardSuit(TrashType.itEquipment),
      CardSuit(TrashType.dryCellBatteries),
      CardSuit(TrashType.vcdOrDvd),
    ],
  ),
];

class GameLevel {
  final int number;

  int maxCards;
  final List<PlayingCard> _hand = [];

  List<CardSuit> cardSuits;

  final Player player = Player();

  GameLevel({
    required this.number,
    required this.maxCards,
    required this.cardSuits,
  });
}

extension ExGameLevel on GameLevel {
  List<PlayingCard> get hand => _hand;

  void shuffle() {
    _hand.shuffle();
    for (final card in _hand) {
      card.rotate();
    }

    // List<PlayingCard> copy = [];
    // for(final card in _hand){
    //   copy.add(PlayingCard.clone(card));
    // }
    // copy.shuffle(Random());
    // _hand.clear();
    // _hand.addAll(copy);

    // Fisher-Yates 洗牌算法
    // final Random random = Random();
    //
    // for (int i = _hand.length - 1; i > 0; i--) {
    //   final int j = random.nextInt(i + 1);
    //   final temp = _hand[i];
    //   _hand[i] = _hand[j];
    //   _hand[j] = temp;
    // }
  }

  String getLevelName(BuildContext context) {
    switch (number) {
      case 1:
        return AppLocalizations.of(context)!.level_01;
      case 2:
        return AppLocalizations.of(context)!.level_02;
      case 3:
        return AppLocalizations.of(context)!.level_03;
      case 4:
        return AppLocalizations.of(context)!.level_04;
      case 5:
        return AppLocalizations.of(context)!.level_05;
      case 6:
        return AppLocalizations.of(context)!.level_06;
      default:
        return '';
    }
  }

  ///產生卡片
  void generateCards() {
    _hand.clear();
    if (_hand.isEmpty) {
      Map<CardSuit, int> cardSuitMaxCountList = {};
      Map<CardSuit, List<int>> cardSuitRandomList = {};

      for (final element in cardSuits) {
        cardSuitMaxCountList[element] = 0;
      }

      // 定義一個隨機數生成器
      Random random = Random();

      // 定義變數用於存儲清單中的偶數的總和
      int counter = maxCards;
      if (counter % 2 != 0) {
        // 如果隨機數不是偶數，則加一使其變為偶數
        counter--;
      }

      final finalGateValue = counter ~/ (cardSuitMaxCountList.length);

      // int minCount = 0;
      // for (final cardSuit in cardSuits) {
      //   int itemsCount = cardSuit.trashType.itemsCount;
      //   if (minCount == 0 || itemsCount < minCount) {
      //     minCount = itemsCount;
      //   }
      // }
      //
      // if (gateValue > minCount) {
      //   gateValue = minCount;
      // }

      // 將任意數平均分配到清單中的每個元素
      cardSuitMaxCountList.forEach((cardSuit, value) {
        int itemsCount = cardSuit.trashType.itemsCount;
        int gateValue = finalGateValue;
        if (gateValue > itemsCount) {
          gateValue = itemsCount;
        }

        int maxCount = gateValue;

        if (cardSuit != cardSuitMaxCountList.keys.last) {
          // 生成一個亂數
          // int gateValue2 = gateValue;
          // if (gateValue2 < counter) {
          //   gateValue2 = counter;
          // }

          if ((gateValue ~/ 2) > 3) {
            maxCount = random.nextBool() ? gateValue : gateValue - 2;
          }

          if (maxCount % 2 != 0 && (maxCount + 1) <= itemsCount) {
            // 如果隨機數不是偶數，則加一使其變為偶數
            maxCount++;
          }

          // 將任意數平均分配到清單中的每個元素
          cardSuitMaxCountList[cardSuit] = maxCount;
          counter -= maxCount;
        } else if (counter > 0 && cardSuit == cardSuitMaxCountList.keys.last) {
          // 如果是最後一個項目，將剩餘的 counter 分配給最後一個項目
          cardSuitMaxCountList[cardSuit] = maxCount;
          counter = 0;
        }

        {
          int halfCardsCount = cardSuitMaxCountList[cardSuit]! ~/ 2;
          cardSuitRandomList[cardSuit] =
              _generateRandomList(cardSuit, halfCardsCount);
          final card =
              _generateDualCards(cardSuit, cardSuitRandomList[cardSuit]!);
          _hand.addAll(card);
        }
      });

      _hand.shuffle(); // 打乱手牌顺序
      //initialStartPicking();
    }
  }

  ///產生亂數清單
  List<int> _generateRandomList(CardSuit cardSuit, int halfCardsCount) {
    List<int> randomList = [];

    for (int i = 0; i < halfCardsCount; i++) {
      int value = -1;
      do {
        value = PlayingCard.randomValue(cardSuit);
      } while (randomList
          .any((valueInList) => valueInList == value)); // 檢查是否已存在相同數字的卡片

      randomList.add(value);
    }

    return randomList;
  }

  ///產生雙卡
  List<PlayingCard> _generateDualCards(
      CardSuit cardSuit, List<int> randomList) {
    List<PlayingCard> cards = [];
    List<PlayingCard> halfCards = [];
    List<PlayingCard> halfCards02 = [];
    for (final value in randomList) {
      halfCards.add(PlayingCard.order(cardSuit, value));
      halfCards02.add(PlayingCard.order(cardSuit, value));
    }

    //BUG
    //點擊1張卡時，相同圖片的2張卡顯示
    cards.addAll(halfCards);
    cards.addAll(halfCards02);

    return cards;
  }

  int get pairCount {
    int counter = 0;
    for (final card in _hand) {
      if (card.isPairingCompleted && card.isPairingRepresentative) {
        counter += 1;
      }
    }
    return counter;
  }
}
