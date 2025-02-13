import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../level_selection/levels.dart';
import '../style/palette.dart';
import 'board_widget.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;

  final GameLevel? level;

  final Player? player;

  const PlayingCardWidget(this.card, {this.player, this.level, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    final cardValue = card.value;
    final frontImagePath = card.suit.frontImagePath;
    final backImagePath = card.suit.backImagePath(cardValue);
    final imagePath = card.isFront ? frontImagePath : backImagePath;

    if (player != null) {
      Widget cardWidget = cardSize(cardSuit(palette, imagePath));

      if (card.isSortedForRecycling) {
        cardWidget = cardSize(null);
      } else if (card.isPairingCompleted) {
        if (card.isPairingRepresentative) {
          //兩張卡重疊
          final cardStack = _PairCardStack(
            card: card,
          );

          cardWidget = cardSize(cardStack);
        } else {
          cardWidget = cardSize(null);
        }
      }

      final cardWidgetAsDrag = Draggable(
        feedback: Transform.rotate(
          angle: 0.1,
          child: cardWidget,
        ),
        data: PlayingCardDragData(card, player!),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: cardWidget,
        ),
        onDragStarted: () {
          final audioController = context.read<AudioController>();
          audioController.playSfx(SfxType.huhsh);
        },
        onDragEnd: (details) {
          final audioController = context.read<AudioController>();
          audioController.playSfx(SfxType.wssh);
        },
        child: cardWidget,
      );

      final tappableCard = InkWell(
        onTap: (!card.isPairingCompleted)
            ? () {
                player!.clickCard(card: card);
              }
            : null,
        child: cardWidget,
      );

      final rotateCardWidget = randomRotate(tappableCard, card.rotateAngle);

      return card.isPairingRepresentative ? cardWidgetAsDrag : rotateCardWidget;
    }

    /// Cards that aren't in a player's hand are not draggable.
    return cardSuit(palette, card.suit.backImagePath(cardValue));
  }

  Widget cardSize(Widget? child) {
    return SizedBox(
      width: BoardWidget.cardWidth + 10,
      height: BoardWidget.cardHeight + 10,
      child: child ?? SizedBox.shrink(),
    );
  }

  Widget randomRotate(Widget child, double rotateAngle) {
    return Transform.rotate(
      angle: rotateAngle,
      child: child,
    );
  }

  Widget cardSuit(Palette palette, String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: BoardWidget.cardWidth,
        height: BoardWidget.cardHeight,
        margin: const EdgeInsets.only(bottom: 6.0, right: 6.0),
        decoration: BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Image.asset(
            imagePath,
            width: BoardWidget.cardWidth - 4,
            gaplessPlayback: true,
          ),
        ),
      ),
    );
  }
}

class _PairCardStack extends StatelessWidget {
  int maxCards = 2;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  double get _maxWidth {
    return maxCards * _leftOffset + BoardWidget.cardWidth;
  }

  double get _maxHeight {
    return maxCards * _topOffset + BoardWidget.cardHeight;
  }

  PlayingCard card;

  _PairCardStack({
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = 0; i < maxCards; i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingCardWidget(card),
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
class PlayingCardDragData {
  final PlayingCard card;

  final Player holder;

  const PlayingCardDragData(this.card, this.holder);
}
