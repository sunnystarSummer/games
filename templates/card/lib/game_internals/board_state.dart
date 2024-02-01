// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:card/level_selection/levels.dart';
import 'package:flutter/foundation.dart';
import 'player.dart';

class BoardState {
  final VoidCallback onWin;

  final Player player = Player();

  int get columnCount {
    int count = level.hand.length;

    // 尋找最接近的平方數，計算行數和列數
    int sqrtValue = sqrt(count).ceil();
    int columnCount = sqrtValue;

    return columnCount;
  }

  int get rowCount {
    int count = level.hand.length;

    // 尋找最接近的平方數，計算行數和列數
    int sqrtValue = sqrt(count).ceil();
    int columnCount = sqrtValue;
    int rowCount = sqrtValue;

    // 如果卡牌數量太多，調整列數以接近正方形
    if (columnCount * (rowCount - 1) >= count) {
      rowCount -= 1;
    }

    return rowCount;
  }

  GameLevel level;

  BoardState(this.level, {required this.onWin}) {
    player.addListener(_handlePlayerChange);
  }

  void dispose() {
    player.removeListener(_handlePlayerChange);
    player.dispose();
  }

  void _handlePlayerChange() {
    bool isWon = false;
    for (final card in level.hand) {
      isWon = card.isSortedForRecycling;
      if (isWon == false) {
        break;
      }
    }

    if (isWon) {
      onWin();
    }
  }

  void openAllCards() {
    for (final card in level.hand) {
      card.isFront = false;
    }
  }

  void coverAllCards() {
    for (final card in level.hand) {
      card.isFront = true;
    }
  }

  void shuffle(){
    level.shuffle();
  }
}
