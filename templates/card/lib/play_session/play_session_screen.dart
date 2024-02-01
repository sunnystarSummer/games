// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:card/game_internals/player.dart';
import 'package:card/level_selection/levels.dart';
import 'package:card/play_session/playing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/board_state.dart';
import '../game_internals/score.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import 'board_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a level.
///
/// It is a stateful widget because it manages some state of its own,
/// such as whether the game is in a "celebration" state.
class PlaySessionScreen extends StatefulWidget {
  GameLevel level;

  PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen>
    with AfterLayoutMixin<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 3000);

  static const _preCelebrationDuration = Duration(milliseconds: 200);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;

  bool isRecyclable = false;
  bool isHighlighted = false;

  int _countdownTime = 3;
  late Timer _timer;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final level = _boardState.level;

    double value = 0.5 / (_boardState.columnCount + 1);
    PlayingCardWidget.height = value.sh;
    PlayingCardWidget.width = PlayingCardWidget.height * (57.1 / 88.9);

    //污染圖片
    const pollutionImagePath = 'assets/images/background/osen_kawa.png';
    //乾淨圖片
    const cleanImagePath = 'assets/images/background/kawa.png';

    //印象圖片
    var impressionImagePath =
        isRecyclable ? cleanImagePath : pollutionImagePath;

    if (_duringCelebration) {
      impressionImagePath = cleanImagePath;
    }

    var opacity = 0.0;
    if (level.pairCount > 0) {
      opacity = level.pairCount / (level.hand.length ~/ 2);
    }

    return MultiProvider(
      providers: [
        Provider.value(value: _boardState),
      ],
      child: IgnorePointer(
        // Ignore all input during the celebration animation.
        ignoring: _duringCelebration,
        child: Scaffold(
          backgroundColor: palette.backgroundPlaySession,
          // The stack is how you layer widgets on top of each other.
          // Here, it is used to overlay the winning confetti animation on top
          // of the game.
          body: Stack(
            children: [
              Visibility(
                visible: isHighlighted || _duringCelebration,
                child: Center(
                  child: Opacity(
                    opacity: opacity,
                    child: Image(
                      image: AssetImage(impressionImagePath),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkResponse(
                      onTap: () => GoRouter.of(context).push('/settings'),
                      child: Image.asset(
                        'assets/images/settings.png',
                        semanticLabel: 'Settings',
                      ),
                    ),
                  ),
                  // const Spacer(),
                  // The actual UI of the game.
                  Align(
                    alignment: Alignment.topCenter,
                    child: BoardWidget(
                      (playingArea) {
                        setState(() {
                          isRecyclable = playingArea.isRecyclable;
                          isHighlighted = playingArea.isHighlighted;

                          if (!level.player.isGood) {
                            _countdownTime = 3;
                            startCountdown();
                          }
                        });
                      },
                    ),
                  ),

                  Text(
                    AppLocalizations.of(context)!.gameHint,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onPressed: () => GoRouter.of(context).go('/play'),
                      child: Text(AppLocalizations.of(context)!.back),
                    ),
                  ),
                ],
              ),
              SizedBox.expand(
                child: Visibility(
                  visible: _duringCelebration,
                  child: IgnorePointer(
                    child: Confetti(
                      isStopped: !_duringCelebration,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !level.player.isGood,
                child: Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: Image(
                      image:
                          AssetImage('assets/images/background/warumono.png'),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: (_countdownTime != -1),
                child: SizedBox.expand(
                  child: AbsorbPointer(
                    absorbing: true, // 将其设置为 true 以禁用用户点击事件
                    child: GestureDetector(
                      onTap: () {
                        // 在此处添加任何您想要防止用户点击时执行的操作
                        debugPrint('Screen is disabled. You cannot click!');
                      },
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 500),
                          child: Text(
                            '$_countdownTime',
                            key: ValueKey<int>(_countdownTime),
                            style: TextStyle(
                              fontSize: 180.0.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _boardState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    _boardState = BoardState(widget.level, onWin: _playerWon);
    startCountdown();
  }

  Future<void> _playerWon() async {
    _log.info('Player won');
    GameLevel level = _boardState.level;

    // TODO: replace with some meaningful score for the card game
    final score = Score(
      1, //level number
      1, //level difficulty
      DateTime.now().difference(_startOfPlay),
    );

    final playerProgress = context.read<PlayerProgress>();
    playerProgress.setLevelReached(level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go(
      '/play/won',
      extra: {
        'score': score,
        'highestLevelReached': playerProgress.highestLevelReached,
      },
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    _boardState.openAllCards();

    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _boardState.coverAllCards();
      });
    });
  }

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    final level = _boardState.level;
    final player = level.player;

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countdownTime == 0) {
          setState(() {
            _countdownTime = -1;

            if(!player.isGood){
              _boardState.shuffle();
              player.isGood = true;
            }
          });
          timer.cancel();
          // 这里可以处理倒计时结束后的逻辑，比如开始游戏等
        } else {
          setState(() {
            _countdownTime--;
          });
        }
      },
    );
  }
}
