// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'levels.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final playerProgress = context.watch<PlayerProgress>();

    return Scaffold(
      backgroundColor: palette.backgroundLevelSelection,
      body: ResponsiveScreen(
        squarishMainArea: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/images/background/gomisuteba.png'),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.selectLevel,
                      style: TextStyle(
                          fontFamily: 'Permanent Marker', fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView(
                    children: [
                      for (final level in gameLevels)
                        ListTile(
                          enabled: playerProgress.highestLevelReached >=
                              level.number - 1,
                          onTap: () {
                            final audioController =
                                context.read<AudioController>();
                            audioController.playSfx(SfxType.buttonTap);

                            GoRouter.of(context)
                                .go('/play/session/${level.number}');
                          },
                          leading: Text(level.number.toString()),
                          title: Text(
                              'Level #${level.number}\n${level.getLevelName(context)}'),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).go('/');
          },
          child: Text(AppLocalizations.of(context)!.back),
        ),
      ),
    );
  }
}
