enum PosterSize {
  w185('w185'),
  w342('w342'),
  w500('w500');

  const PosterSize(this.value);

  final String value;
}

enum BackdropSize {
  w780('w780'),
  w1280('w1280');

  const BackdropSize(this.value);

  final String value;
}

class TmdbImage {
  const TmdbImage._();

  static const String _baseUrl = 'https://image.tmdb.org/t/p';

  static String? poster(String? path, {PosterSize size = PosterSize.w342}) =>
      _url(path, size.value);

  static String? backdrop(
    String? path, {
    BackdropSize size = BackdropSize.w780,
  }) => _url(path, size.value);

  static String? _url(String? path, String size) {
    if (path == null || path.isEmpty) return null;
    final withLeadingSlash = path.startsWith('/') ? path : '/$path';
    return '$_baseUrl/$size$withLeadingSlash';
  }
}
