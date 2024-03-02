import 'package:card/game_internals/playing_card.dart';
import 'package:card/level_selection/levels.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/board_state.dart';
import 'board_widget.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  const PlayerHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    final level = boardState.level;
    final List<PlayingCard> hand = level.hand;
    final count = hand.length;
    final columnCount = boardState.columnCount;
    final rowCount = boardState.rowCount;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: BoardWidget.cardHeight),
        child: ListenableBuilder(
          // Make sure we rebuild every time there's an update
          // to the player's hand.
          listenable: boardState.player,
          builder: (context, child) {
            return Column(
              children: List.generate(
                rowCount,
                (rowIndex) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      columnCount,
                      (columnIndex) {
                        int index = rowIndex * columnCount + columnIndex;

                        if (index < count) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0), // 添加間距
                            child: PlayingCardWidget(
                              //key: ValueKey<PlayingCard>(hand[index]),
                              hand[index],
                              level: level,
                              player: boardState.player,
                            ),
                          );
                        } else {
                          return SizedBox(); // 如果超出索引範圍，返回一個空的 SizedBox
                        }
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
