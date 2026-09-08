import 'package:cinetrack/src/core/theme/app_theme.dart';
import 'package:cinetrack/src/core/theme/theme_mode_notifier.dart';
import 'package:cinetrack/src/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CineTrackApp extends ConsumerWidget {
  const CineTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'CineTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeModeProvider),
      home: const HomePage(),
    );
  }
}
