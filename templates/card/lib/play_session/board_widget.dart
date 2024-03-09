// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/level_selection/levels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import '../game_internals/playing_area.dart';
import 'player_hand_widget.dart';
import 'playing_area_widget.dart';

/// This widget defines the game UI itself, without things like the settings
/// button or the back button.
class BoardWidget extends StatefulWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static double cardWidth = 0.095.sw;
  static double cardHeight = cardWidth * (88.9 / 57.1);

  final ValueChanged<PlayingArea> onHighlight;

  const BoardWidget(this.onHighlight, {super.key});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  final List<PlayingArea> _playingAreaList = [];

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();

    double value = 0.5 / (boardState.columnCount + 1);
    BoardWidget.cardHeight = value.sh;
    BoardWidget.cardWidth = BoardWidget.cardHeight * (57.1 / 88.9);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
            stream: boardState.player.allChanges,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: playingAreas,
              );
            },
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

  List<Widget> get playingAreas {
    final boardState = context.watch<BoardState>();
    GameLevel level = boardState.level;

    List<Widget> list = [];
    if(_playingAreaList.isEmpty){
      for (final cardSuit in level.cardSuits) {
        final playingArea = PlayingArea(
          trashType: cardSuit.trashType,
        );
        _playingAreaList.add(playingArea);
      }
    }

    for (final playingArea in _playingAreaList) {
      final playingAreaWidget = PlayingAreaWidget(
        playingArea,
        level,
        widget.onHighlight,
      );
      list.add(playingAreaWidget);
      list.add(SizedBox(width: 10));
    }

    if (list.isNotEmpty) {
      list.removeLast();
    }

    return list;
  }
}
