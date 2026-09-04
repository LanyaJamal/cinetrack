/// Build time config, passed with --dart-define-from-file=env.json.
class EnvConfig {
  const EnvConfig._();

  static const String tmdbAccessToken = String.fromEnvironment(
    'TMDB_ACCESS_TOKEN',
  );

  static bool get hasTmdbAccessToken => tmdbAccessToken.isNotEmpty;
}
