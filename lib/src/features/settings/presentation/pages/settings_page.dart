import 'dart:async';

import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:cinetrack/src/core/theme/theme_mode_notifier.dart';
import 'package:cinetrack/src/features/settings/presentation/widgets/theme_mode_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _themeOptions = <(ThemeMode, IconData, String)>[
  (ThemeMode.system, Icons.brightness_auto_outlined, 'System'),
  (ThemeMode.light, Icons.light_mode_outlined, 'Light'),
  (ThemeMode.dark, Icons.dark_mode_outlined, 'Dark'),
];

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
              child: Text(
                'APPEARANCE',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            ClipRSuperellipse(
              borderRadius: AppShape.mediumRadius,
              child: ColoredBox(
                color: theme.colorScheme.surfaceContainerLow,
                child: Column(
                  children: [
                    for (final (mode, icon, label) in _themeOptions) ...[
                      if (mode != _themeOptions.first.$1)
                        Divider(
                          height: 1,
                          indent: 51,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ThemeModeTile(
                        icon: icon,
                        label: label,
                        selected: mode == selected,
                        onTap: () {
                          if (mode == selected) return;
                          unawaited(HapticFeedback.selectionClick());
                          unawaited(
                            ref.read(themeModeProvider.notifier).select(mode),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
              child: Text(
                'System follows your device setting.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
