// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:card/level_selection/levels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import '../game_internals/playing_area.dart';
import 'player_hand_widget.dart';
import 'playing_area_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  final ChangeCallback<PlayingArea> onHighlight;

  const BoardWidget(this.onHighlight, {super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final List<PlayingArea> _playingAreaList = [];

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    GameLevel level = boardState.level;

    List<Widget> list = [];
    for (final cardSuit in level.cardSuits) {
      final playingArea = PlayingArea(
        trashType: cardSuit.trashType,
      );
      final playingAreaWidget = PlayingAreaWidget(
        playingArea,
        level,
        widget.onHighlight,
      );
      list.add(playingAreaWidget);
      _playingAreaList.add(playingArea);
      list.add(SizedBox(width: 10));
    }

    if (list.isNotEmpty) {
      list.removeLast();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: list,
          ),
        ),
        PlayerHandWidget(),
      ],
    );
  }

  @override
  void dispose() {
    for (final element in _playingAreaList) {
      element.dispose();
    }
    super.dispose();
  }
}
