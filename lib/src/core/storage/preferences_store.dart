import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceKeys {
  const PreferenceKeys._();

  static const String watchlist = 'watchlist.movies';
  static const String themeMode = 'settings.theme_mode';
}

final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw StateError('preferencesProvider must be overridden in main()');
});
