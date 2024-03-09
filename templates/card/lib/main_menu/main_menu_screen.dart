// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../settings/settings.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/symbolic_flag.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        squarishMainArea: _MainBackground(),
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

class _MainBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Locale deviceLocale = View.of(context).platformDispatcher.locale;
    final countryCode = deviceLocale.countryCode ?? '';
    final languageCode = deviceLocale.languageCode;

    Widget playerFlag = SymbolicFlag(countryCode, languageCode);

    final db = FirebaseFirestore.instance;
    final collection = db.collection("score_board");

    return FutureBuilder(
      future: collection.get(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        Map<String, dynamic> heightData = {
          'languageCode': '',
          'countryCode': '',
          'happinessPercentage': '0',
        };

        String happinessPercentage = '';
        double happinessScale = 0.0;
        var textColor = Colors.black;
        Widget heightScoreFlag = SizedBox.shrink();
        List<TableRow> tableRows = [];

        if (snapshot.hasData) {
          final event = snapshot.requireData;

          BigInt heightNumber = BigInt.parse('0');

          var totalNumber = BigInt.parse('0');
          var deviceScore = BigInt.parse('0');

          List countries = [];

          for (final doc in event.docs) {
            Map<String, dynamic> docData = doc.data();
            final scoreText = docData['score'] as String;
            final scoreNumber = BigInt.parse(scoreText);
            final languageCode = (docData['languageCode'] as String);

            countries.add(docData);

            if (deviceLocale.languageCode == languageCode) {
              deviceScore = scoreNumber;
            }

            if (scoreNumber > heightNumber) {
              heightNumber = scoreNumber;
              heightData = docData;
            }

            totalNumber += scoreNumber;
          }

          // Sort from big to small.
          countries.sort((a, b) {
            final scoreTextA = a['score'] as String;
            final scoreTextB = b['score'] as String;
            return BigInt.parse(scoreTextB).compareTo(BigInt.parse(scoreTextA));
          });

          for (final country in countries) {
            final countryCode = (country['countryCode'] as String);
            final languageCode = (country['languageCode'] as String);
            final scoreText = country['score'] as String;
            final scoreNumber = BigInt.parse(scoreText);
            final happinessScale = scoreNumber / totalNumber;
            final happinessPercentage =
                '${(happinessScale * 100).toStringAsFixed(2)}%';

            final flag = SymbolicFlag(
              countryCode,
              languageCode,
              height: 20,
            );

            tableRows.add(TableRow(
              children: [
                //Text('Name'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: flag,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(flag.countryName),
                    //Text((country['languageCode'] as String)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                        happinessPercentage), //Text((country['score'] as String)),
                  ),
                ),
              ],
            ));
          }

          final languageCode = (heightData['languageCode'] as String);
          final countryCode = (heightData['countryCode'] as String);

          if (languageCode.isNotEmpty || countryCode.isNotEmpty) {
            textColor = languageCode == deviceLocale.languageCode
                ? Colors.amber
                : Colors.black;

            heightScoreFlag = SymbolicFlag(countryCode, languageCode);
          }

          happinessScale = deviceScore / totalNumber;
          debugPrint('deviceScore: $deviceScore');
          debugPrint('totalNumber: $totalNumber');
          debugPrint('happinessScale: $happinessScale');

          int value = happinessScale * 100 ~/ 1;
          happinessPercentage = '${(happinessScale * 100).toStringAsFixed(2)}%';
        }

        return Stack(children: [
          Center(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                  'assets/images/card_suit/earth_nature_futaba.png'),
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.4,
              child: Transform.scale(
                scale: 1.0,
                child: heightScoreFlag,
              ),
            ),
          ),
          // Center(
          //   child: Opacity(
          //     opacity: 0.4,
          //     child: Transform.scale(
          //       scale: happinessScale,
          //       child: playerFlag,
          //     ),
          //   ),
          // ),
          Column(
            children: [
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
              SizedBox(height: 30),
              Flexible(
                child: Table(
                  // defaultColumnWidth: IntrinsicColumnWidth(),
                  defaultColumnWidth: FixedColumnWidth(100.0),
                  // columnWidths: const {
                  //   0: FlexColumnWidth(),
                  //   1: FlexColumnWidth(),
                  //   2: FlexColumnWidth(),
                  // },
                  children: tableRows,
                ),
              ),
            ],
          ),
        ]);
      },
    );
  }
}
