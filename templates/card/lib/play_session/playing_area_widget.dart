import 'dart:math';

import 'package:card/game_internals/card_suit.dart';
import 'package:card/level_selection/levels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';
import 'playing_card_widget.dart';

typedef ChangeCallback<T> = void Function(T value);

class PlayingAreaWidget extends StatefulWidget {
  final PlayingArea area;
  final GameLevel level;
  final ChangeCallback<PlayingArea> onHighlight;

  const PlayingAreaWidget(this.area, this.level, this.onHighlight, {super.key});

  @override
  State<PlayingAreaWidget> createState() => _PlayingAreaWidgetState();
}

class _PlayingAreaWidgetState extends State<PlayingAreaWidget> {
  late PlayingArea area;

  @override
  void initState() {
    super.initState();
    area = widget.area;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    var areaColor = Colors.transparent;

    if (area.isHighlighted) {
      areaColor =
          area.isRecyclable ? palette.recyclable : palette.notRecyclable;
    }

    return LimitedBox(
      maxWidth: _containerWidth,
      child: Column(
        children: [
          Text(
            widget.area.trashType.typeName(context),
            textAlign: TextAlign.center,
          ),
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Material(
                  color: palette.trueWhite,
                  shape: CircleBorder(), //BeveledRectangleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox.shrink(),
                ),
              ),
              AspectRatio(
                aspectRatio: 1 / 1,
                child: DragTarget<PlayingCardDragData>(
                  builder: (context, candidateData, rejectedData) => SizedBox(
                    width: _containerWidth,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: _containerWidth * (1.4 / 2),
                            child: widget.area.trashType.trashTypeImage,
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: StreamBuilder(
                            stream: widget.area.allChanges,
                            builder: (context, child) {
                              final cardStack = _CardStack(widget.area.cards);
                              if (area.isHighlighted) {
                                return Stack(
                                  children: [
                                    cardStack,
                                    Opacity(
                                      opacity: (areaColor == palette.recyclable)
                                          ? 0.0
                                          : 1.0,
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/background/kinshi.png'),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return cardStack;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  onWillAcceptWithDetails: _onDragWillAccept,
                  onLeave: _onDragLeave,
                  onAcceptWithDetails: _onDragAccept,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double get _containerWidth {
    var cardSuitsCount = widget.level.cardSuits.length;
    cardSuitsCount += 2;

    if (1.sw < 1.sh) {
      return (1 / cardSuitsCount).sw;
    } else {
      return (1 / cardSuitsCount).sh;
    }
  }

  void _onAreaTap() {
    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.huhsh);
  }

  void _onDragAccept(DragTargetDetails<PlayingCardDragData> details) {
    area.isRecyclable =
        details.data.card.suit.trashType == widget.area.trashType;
    area.isRecyclable = area.isRecyclable && area.isHighlighted;

    if (area.isRecyclable) {
      details.data.card.isSortedForRecycling = true;
      widget.area.acceptCard(details.data.card);
      details.data.holder.notifyChange();

      setState(() {
        area.isRecyclable = false;
      });
    }else{
      setState(() {
        widget.level.player.isGood = false;
      });
    }

    setState(() {
      area.isHighlighted = false;
    });

    widget.onHighlight(area);
  }

  void _onDragLeave(PlayingCardDragData? data) {
    setState(() {
      area.isRecyclable = false;
      area.isHighlighted = false;
    });

    widget.onHighlight(area);
  }

  bool _onDragWillAccept(DragTargetDetails<PlayingCardDragData> details) {
    setState(() {
      area.isRecyclable =
          details.data.card.suit.trashType == widget.area.trashType;
      area.isHighlighted = true;
    });

    widget.onHighlight(area);
    return true;
  }
}

class _CardStack extends StatelessWidget {
  static const int _maxCards = 6;

  static const _leftOffset = 10.0;

  static const _topOffset = 5.0;

  double get _maxWidth {
    return _maxCards * _leftOffset + PlayingCardWidget.width;
  }

  double get _maxHeight {
    return _maxCards * _topOffset + PlayingCardWidget.height;
  }

  final List<PlayingCard> cards;

  const _CardStack(this.cards);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: _maxWidth,
        height: _maxHeight,
        child: Stack(
          children: [
            for (var i = max(0, cards.length - _maxCards);
                i < cards.length;
                i++)
              Positioned(
                top: i * _topOffset,
                left: i * _leftOffset,
                child: PlayingCardWidget(cards[i]),
              ),
          ],
        ),
      ),
    );
  }
}
