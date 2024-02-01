// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

  const WinGameScreen({
    super.key,
    required this.score,
    required this.highestLevelReached,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.4,
                child: Image(
                  image: AssetImage('assets/images/background/earth_good.png'),
                ),
              ),
            ),
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
