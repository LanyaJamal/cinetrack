import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:cinetrack/src/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';

Route<void> movieDetailRoute(MovieModel movie, {required String heroTag}) {
  return MaterialPageRoute<void>(
    builder: (context) => MovieDetailPage(movie: movie, heroTag: heroTag),
  );
}

Route<void> settingsRoute() {
  return MaterialPageRoute<void>(builder: (context) => const SettingsPage());
}
