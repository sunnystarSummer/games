import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../level_selection/levels.dart';
import '../style/palette.dart';

class PlayingCardWidget extends StatefulWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static double width = 0.095.sw;

  static double height = width * (88.9 / 57.1);

  final PlayingCard card;

  final GameLevel? level;

  final Player? player;

  const PlayingCardWidget(this.card, {this.player, this.level, super.key});

  @override
  State<PlayingCardWidget> createState() => _PlayingCardWidgetState();
}

class _PlayingCardWidgetState extends State<PlayingCardWidget> {
  late final PlayingCard card;

  late final Player? player;

  bool isHighlighted = false;
  bool isTheSameTrashType = false;

  @override
  void initState() {
    super.initState();
    card = widget.card;
    player = widget.player;

    card.rotate();
  }

  @override
  Widget build(BuildContext context) {
    final boardState = context.watch<BoardState>();
    final cardValue = card.value;
    final frontImagePath = card.suit.frontImagePath;
    final backImagePath = card.suit.backImagePath(cardValue);

    if (player != null) {
      final cardWidget = SizedBox(
        width: PlayingCardWidget.width + 10,
        height: PlayingCardWidget.height + 10,
        child: ListenableBuilder(
          // Make sure we rebuild every time there's an update
          // to the player's hand.
          listenable: boardState.player,
          builder: (context, child) {
            return FutureBuilder(
              future: Future.value(card.isFront),
              builder: (BuildContext context, AsyncSnapshot<Object?> snap) {
                final imagePath = card.isFront ? frontImagePath : backImagePath;

                if (card.isSortedForRecycling) {
                  return SizedBox.shrink();
                }

                if (card.isPairingCompleted) {
                  if (card.isPairingRepresentative) {
                    //兩張卡重疊
                    final cardStack = _PairCardStack(
                      card: card,
                    );

                    return cardStack;
                  } else {
                    return SizedBox.shrink();
                  }
                }

                return cardSuit(imagePath);
              },
            );
          },
        ),
      );

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
    return cardSuit(card.suit.backImagePath(cardValue));
  }

  Widget randomRotate(Widget child, double rotateAngle) {
    return Transform.rotate(
      angle: rotateAngle,
      child: child,
    );
  }

  Widget cardSuit(String imagePath) {
    final palette = context.watch<Palette>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: PlayingCardWidget.width,
        height: PlayingCardWidget.height,
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
          child: Image(
            fit: BoxFit.contain,
            image: AssetImage(imagePath),
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
    return maxCards * _leftOffset + PlayingCardWidget.width;
  }

  double get _maxHeight {
    return maxCards * _topOffset + PlayingCardWidget.height;
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
