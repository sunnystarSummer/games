// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenuScreen extends StatelessWidget {
  MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    final Locale deviceLocale = View.of(context).platformDispatcher.locale;
    final countryCode = deviceLocale.countryCode ?? '';
    final languageCode = deviceLocale.languageCode;

    Widget flag = Flag.fromString(
      countryCode,
      borderRadius: 8,
    );

    if (countryCode.isEmpty) {
      flag = Flag.fromString(
        languageCode,
        borderRadius: 8,
      );
    }

    if (countryCode == 'TW') {
      flag = Image.asset('assets/images/background/Meihua_ROC.png');
    }

    String doc = deviceLocale.languageCode;
    if (countryCode.isNotEmpty) {
      doc = '${deviceLocale.countryCode ?? ''}_${deviceLocale.languageCode}';
    }

    final db = FirebaseFirestore.instance;
    final collection = db.collection("score_board");
    final document = collection.doc(doc);

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: Stack(
          children: [
            Center(
              child: FutureBuilder(
                future: collection.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  Map<String, dynamic> heightData = {
                    'languageCode': '',
                    'countryCode': '',
                    'happinessPercentage': '0',
                  };

                  String happinessPercentage = '';
                  double happinessScale = 0.0;
                  var textColor = Colors.black;
                  Widget heightScoreFlag = SizedBox.shrink();

                  if (snapshot.hasData) {
                    final event = snapshot.requireData;

                    BigInt heightNumber = BigInt.parse('0');

                    var totalNumber = BigInt.parse('0');
                    var deviceScore = BigInt.parse('0');
                    for (final doc in event.docs) {
                      Map<String, dynamic> docData = doc.data();
                      final scoreText = docData['score'] as String;
                      final scoreNumber = BigInt.parse(scoreText);
                      final languageCode = (docData['languageCode'] as String);

                      if (deviceLocale.languageCode == languageCode) {
                        deviceScore = scoreNumber;
                      }

                      if (scoreNumber > heightNumber) {
                        heightNumber = scoreNumber;
                        heightData = docData;
                      }

                      totalNumber += scoreNumber;
                    }

                    final languageCode = (heightData['languageCode'] as String);
                    final countryCode = (heightData['countryCode'] as String);

                    if (languageCode.isNotEmpty || countryCode.isNotEmpty) {
                      textColor = heightData['languageCode'] ==
                              deviceLocale.languageCode
                          ? Colors.amber
                          : Colors.black;

                      if (deviceLocale.languageCode != languageCode) {
                        heightScoreFlag = Flag.fromString(
                          countryCode,
                          borderRadius: 8,
                        );

                        if (countryCode.isEmpty) {
                          heightScoreFlag = Flag.fromString(
                            languageCode,
                            borderRadius: 8,
                          );
                        }

                        if (countryCode == 'TW') {
                          heightScoreFlag = Image.asset(
                              'assets/images/background/Meihua_ROC.png');
                        }
                      }
                    }

                    happinessScale = deviceScore / totalNumber;
                    debugPrint('deviceScore: $deviceScore');
                    debugPrint('totalNumber: $totalNumber');
                    debugPrint('happinessScale: $happinessScale');

                    int value = happinessScale * 100 ~/ 1;
                    happinessPercentage =
                        '${(happinessScale * 100).toStringAsFixed(2)}%';
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.asset(
                                'assets/images/card_suit/earth_nature_futaba.png'),
                          ),
                        ),
                        Opacity(
                          opacity: 0.2,
                          child: Transform.scale(
                            scale: 1.0,
                            child: heightScoreFlag,
                          ),
                        ),
                        Opacity(
                          opacity: 0.4,
                          child: Transform.scale(
                            scale: happinessScale,
                            child: flag,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Transform.rotate(
                            angle: -0.1,
                            child: Column(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.gameName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: 'Permanent Marker',
                                    fontSize: 55,
                                    height: 1,
                                  ),
                                ),
                                Text(
                                  happinessPercentage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Permanent Marker',
                                    fontSize: 55,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MyButton(
              onPressed: () {
                audioController.playSfx(SfxType.buttonTap);
                GoRouter.of(context).go('/play');
              },
              child: Text(AppLocalizations.of(context)!.play),
            ),
            _gap,
            MyButton(
              onPressed: () => GoRouter.of(context).push('/settings'),
              child: Text(AppLocalizations.of(context)!.settings),
            ),
            _gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.audioOn,
                builder: (context, audioOn, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleAudioOn(),
                    icon: Icon(audioOn ? Icons.volume_up : Icons.volume_off),
                  );
                },
              ),
            ),
            _gap,
            Text(AppLocalizations.of(context)!.musicByMrSmith),
            _gap,
          ],
        ),
      ),
    );
  }

  static const _gap = SizedBox(height: 10);
}
