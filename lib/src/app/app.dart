import 'package:cinetrack/src/core/theme/app_theme.dart';
import 'package:cinetrack/src/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class CineTrackApp extends StatelessWidget {
  const CineTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineTrack',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
