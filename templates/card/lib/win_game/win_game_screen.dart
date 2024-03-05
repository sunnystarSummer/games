// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../game_internals/score.dart';
import '../level_selection/levels.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WinGameScreen extends StatelessWidget {
  final Score score;
  final int highestLevelReached;
  final Map<String, dynamic> localCountryData;

  const WinGameScreen({
    super.key,
    required this.score,
    required this.highestLevelReached,
    required this.localCountryData,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    final countryCode = localCountryData['countryCode'] as String;
    final deviceLanguageCode = localCountryData['languageCode'] as String;

    final db = FirebaseFirestore.instance;
    final collection = db.collection("score_board");

    Widget flag = Flag.fromString(
      countryCode,
      borderRadius: 8,
    );

    if (countryCode.isEmpty) {
      flag = Flag.fromString(
        deviceLanguageCode,
        borderRadius: 8,
      );
    }

    if (countryCode == 'TW') {
      flag = Image.asset('assets/images/background/Meihua_ROC.png');
    }

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
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

                      if (deviceLanguageCode == languageCode) {
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
                      textColor =
                          heightData['languageCode'] == deviceLanguageCode
                              ? Colors.amber
                              : Colors.black;

                      if (deviceLanguageCode != languageCode) {
                        heightScoreFlag = Flag.fromString(
                          countryCode,
                          borderRadius: 8,
                        );
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
                        Center(
                          child: Opacity(
                            opacity: 0.2,
                            child: Image.asset(
                                'assets/images/background/earth_good.png'),
                          ),
                        ),
                        // Opacity(
                        //   opacity: 0.2,
                        //   child: Transform.scale(
                        //     scale: 1.0,
                        //     child: heightScoreFlag,
                        //   ),
                        // ),
                        Center(
                          child: Opacity(
                            opacity: 0.4,
                            child: Text(
                              happinessPercentage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Permanent Marker',
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Opacity(
                            opacity: 0.4,
                            child: Transform.scale(
                              scale: happinessScale,
                              child: flag,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  );
                },
              ),
            ),
            // Center(
            //   child: Opacity(
            //     opacity: 0.2,
            //     child: flag,
            //   ),
            // ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                gap,
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.youWon,
                    style:
                        TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
                  ),
                ),
                gap,
                Center(
                  child: Text(
                    '${AppLocalizations.of(context)!.score}: ${score.score}\n'
                    '${AppLocalizations.of(context)!.time}: ${score.formattedTime}',
                    style:
                        TextStyle(fontFamily: 'Permanent Marker', fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            //GoRouter.of(context).go('/play');
            final nextLevel = highestLevelReached + 1;
            if (nextLevel < (gameLevels.length + 1)) {
              GoRouter.of(context).go('/play/session/$nextLevel');
            } else {
              GoRouter.of(context).go('/play');
            }
          },
          child: Text(AppLocalizations.of(context)!.continueText),
        ),
      ),
    );
  }
}
