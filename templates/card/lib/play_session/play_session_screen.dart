// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:card/level_selection/levels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
import '../widgets/symbolic_flag.dart';
import 'board_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

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

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 1000);

  static const _preCelebrationDuration = Duration(milliseconds: 200);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late final BoardState _boardState;

  bool isRecyclable = false;
  bool isHighlighted = false;

  late final GameLevel level;

  late Stream<int> _countdownTime;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

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

    double value = 0.5 / (_boardState.columnCount + 1);
    BoardWidget.cardHeight = value.sh;
    BoardWidget.cardWidth = BoardWidget.cardHeight * (57.1 / 88.9);

    final Locale deviceLocale = View.of(context).platformDispatcher.locale;
    final countryCode = deviceLocale.countryCode ?? '';
    final languageCode = deviceLocale.languageCode;

    Widget flag = SymbolicFlag(countryCode, languageCode);

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
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: 0.2,
                    child: flag,
                  ),
                ),
              ),
              Visibility(
                visible: isHighlighted || _duringCelebration,
                child: Center(
                  child: Opacity(
                    opacity: opacity,
                    child: Image.asset(impressionImagePath),
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
                  StreamBuilder(
                    stream: _boardState.player.allChanges,
                    builder: (context, child) {
                      final comboValue = _boardState.player.combo;

                      const hint = 'DO YOU BEST';
                      String comboText = hint;
                      if (comboValue == (level.hand.length ~/ 2)) {
                        comboText = 'x$comboValue BONUS';

                        return Text(
                          comboText,
                          key: ValueKey<int>(comboValue),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Permanent Marker',
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (comboValue != 0) {
                        //紅利
                        comboText = 'x$comboValue BONUS';
                        if (comboValue == 1) {
                          comboText = hint;
                        }
                      }

                      return Text(
                        comboText,
                        key: ValueKey<int>(comboValue),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Permanent Marker',
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: true,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: BoardWidget(
                        (playingArea) {
                          setState(() {
                            isRecyclable = playingArea.isRecyclable;
                            isHighlighted = playingArea.isHighlighted;

                            if (!level.player.isGood) {
                              startCountdown(() {
                                setState(() {
                                  if (!level.player.isGood) {
                                    _boardState.shuffle();
                                    level.player.isGood = true;

                                    // _boardState.player.combo =
                                    //     -_boardState.player.combo.abs();
                                    _boardState.player.combo = 0;
                                  }
                                });
                              });
                            }
                          });
                        },
                      ),
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
                    child: Image.asset('assets/images/background/warumono.png'),
                  ),
                ),
              ),
              StreamBuilder<int>(
                stream: _countdownTime,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    final countdownTime = snapshot.requireData;

                    return Visibility(
                      visible: (countdownTime != -1),
                      child: SizedBox.expand(
                        child: AbsorbPointer(
                          absorbing: true, // 将其设置为 true 以禁用用户点击事件
                          child: GestureDetector(
                            onTap: () {
                              // 在此处添加任何您想要防止用户点击时执行的操作
                              debugPrint(
                                  'Screen is disabled. You cannot click!');
                            },
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                child: Text(
                                  '$countdownTime',
                                  key: ValueKey<int>(countdownTime),
                                  style: TextStyle(
                                    fontSize: 90.0.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _boardState.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    level = widget.level;
    _startOfPlay = DateTime.now();
    _boardState = BoardState(level, onWin: _playerWon);
    level.generateCards();
    _boardState.rotateAllCards();
    _boardState.openAllCards();
    startCountdown(() {
      setState(() {
        _boardState.coverAllCards();
      });
    });
  }

  Future<void> _playerWon() async {
    _log.info('Player won');

    // TODO: replace with some meaningful score for the card game
    // final score = Score(
    //   1, //level number
    //   1, //level difficulty
    //   DateTime.now().difference(_startOfPlay),
    // );

    final duration = DateTime.now().difference(_startOfPlay);
    // The higher the difficulty, the higher the score.
    var gameScore = 1;
    // The lower the time to beat the level, the higher the score.
    gameScore *= 10000 ~/ (duration.inSeconds.abs() + 1);

    if (_boardState.player.combo > 1) {
      gameScore *= _boardState.player.combo;
    }

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

    // 取得當前的語系
    // Locale currentLocale = Localizations.localeOf(context);
    // final languageCode = currentLocale.languageCode;
    final Locale locale = View.of(context).platformDispatcher.locale;
    String deviceLocale = '${locale.countryCode ?? ''}_${locale.languageCode}';

    final db = FirebaseFirestore.instance;
    final collection = db.collection("score_board");
    final localCountryDoc = collection.doc(deviceLocale);

    BigInt result = BigInt.parse('0');
    BigInt scoreNumber = BigInt.parse('0');

    Map<String, dynamic> localCountryData = {
      'score': '',
      'happinessPercentage': '',
      'languageCode': locale.languageCode,
      'countryCode': locale.countryCode ?? '',
    };

    await localCountryDoc.get().then((event) async {
      if (event.exists) {
        localCountryData = event.data() ?? {};
        final scoreText = localCountryData['score'] as String;
        try {
          scoreNumber = BigInt.parse(scoreText);
        } catch (e) {
          scoreNumber = BigInt.parse('0');
        }

        result = scoreNumber + BigInt.from(gameScore);
        localCountryData['score'] = result.toString();

        await localCountryDoc.update(localCountryData);
      } else {
        result = BigInt.from(gameScore);
        localCountryData['score'] = result.toString();

        await localCountryDoc.set(localCountryData);
      }
    });

    double happinessPercentage = 0;
    await collection.get().then((event) async {
      BigInt totalNumber = BigInt.parse('0');
      BigInt heightNumber = BigInt.parse('0');

      for (final doc in event.docs) {
        Map<String, dynamic> docData = doc.data();
        final scoreText = docData['score'] as String;
        final scoreNumber = BigInt.parse(scoreText);
        totalNumber += scoreNumber;

        if (scoreNumber > heightNumber) {
          heightNumber = scoreNumber;
        }
      }

      localCountryData['happinessPercentage'] = 0;

      if (totalNumber.toInt() != 0) {
        happinessPercentage = (result / totalNumber).toDouble() * 100;

        localCountryData['happinessPercentage'] =
            happinessPercentage.toStringAsFixed(0);
      }

      await localCountryDoc.set(localCountryData);
    });

    Map<String, dynamic> heightDocData = {};
    await collection.get().then((event) {
      BigInt heightNumber = BigInt.parse('0');

      for (final doc in event.docs) {
        Map<String, dynamic> docData = doc.data();
        final scoreText = docData['score'] as String;
        final scoreNumber = BigInt.parse(scoreText);

        if (scoreNumber > heightNumber) {
          heightNumber = scoreNumber;
          heightDocData = docData;
        }
      }
    });

    await Future.sync((){
      final score = Score(
        result,
        DateTime.now().difference(_startOfPlay),
        level.number,
      );

      GoRouter.of(context).go(
        '/play/won',
        extra: {
          'score': score,
          'highestLevelReached': playerProgress.highestLevelReached,
          'happinessPercentage': happinessPercentage.toStringAsFixed(0),
          'heightDocData': localCountryData,
        },
      );
    });
  }

  void startCountdown(void Function()? finish) {
    _countdownTime = (() {
      late final StreamController<int> controller;
      controller = StreamController<int>(
        onListen: () {
          int countdownTime = 3;
          controller.add(countdownTime);
          const oneSec = Duration(seconds: 1);

          Timer.periodic(
            oneSec,
            (Timer timer) async {
              if (countdownTime == 0) {
                controller.add(-1);
                if (finish != null) {
                  finish();
                }
                timer.cancel();
                await controller.close();
              } else {
                countdownTime--;
                controller.add(countdownTime);
              }
            },
          );
        },
      );
      return controller.stream;
    })();
  }
}
