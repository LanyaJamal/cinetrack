import 'dart:convert';

import 'package:cinetrack/src/core/storage/preferences_store.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WatchlistLocalDataSource {
  List<MovieModel> readAll();

  Future<void> writeAll(List<MovieModel> movies);
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  WatchlistLocalDataSourceImpl({required this.preferences});

  final SharedPreferences preferences;

  @override
  List<MovieModel> readAll() {
    final stored = preferences.getString(PreferenceKeys.watchlist);
    if (stored == null || stored.isEmpty) return const [];
    final decoded = jsonDecode(stored);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(MovieModel.fromJson)
        .toList();
  }

  @override
  Future<void> writeAll(List<MovieModel> movies) {
    final encoded = jsonEncode([for (final movie in movies) movie.toJson()]);
    return preferences.setString(PreferenceKeys.watchlist, encoded);
  }
}

final watchlistLocalDataSourceProvider = Provider<WatchlistLocalDataSource>((
  ref,
) {
  return WatchlistLocalDataSourceImpl(
    preferences: ref.watch(preferencesProvider),
  );
});
