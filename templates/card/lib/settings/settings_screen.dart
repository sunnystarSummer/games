// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.backgroundSettings,
      body: ResponsiveScreen(
        squarishMainArea: ListView(
          children: [
            _gap,
            Text(
              AppLocalizations.of(context)!.settings,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Permanent Marker',
                fontSize: 55,
                height: 1,
              ),
            ),
            _gap,
            // _NameChangeLine(AppLocalizations.of(context)!.name),
            ValueListenableBuilder<bool>(
              valueListenable: settings.soundsOn,
              builder: (context, soundsOn, child) => _SettingsLine(
                AppLocalizations.of(context)!.soundFX,
                Icon(soundsOn ? Icons.graphic_eq : Icons.volume_off),
                onSelected: () => settings.toggleSoundsOn(),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: settings.musicOn,
              builder: (context, musicOn, child) => _SettingsLine(
                AppLocalizations.of(context)!.music,
                Icon(musicOn ? Icons.music_note : Icons.music_off),
                onSelected: () => settings.toggleMusicOn(),
              ),
            ),
            _SettingsLine(
              AppLocalizations.of(context)!.resetProgress,
              const Icon(Icons.delete),
              onSelected: () {
                context.read<PlayerProgress>().reset();

                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)!.hasBeenReset)),
                );
              },
            ),
            _gap,
          ],
        ),
        rectangularMenuArea: MyButton(
          onPressed: () {
            GoRouter.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.back),
        ),
      ),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Permanent Marker',
                  fontSize: 30,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
