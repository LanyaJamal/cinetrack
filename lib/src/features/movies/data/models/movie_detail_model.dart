import 'package:cinetrack/src/core/utils/json_value.dart';

class MovieDetailModel {
  const MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.runtimeInMinutes,
    this.tagline,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] as int,
      title: textOrEmpty(json['title']),
      overview: textOrEmpty(json['overview']),
      voteAverage: doubleOrZero(json['vote_average']),
      voteCount: json['vote_count'] as int? ?? 0,
      genres: _genresFrom(json['genres']),
      posterPath: textOrNull(json['poster_path']),
      backdropPath: textOrNull(json['backdrop_path']),
      releaseDate: dateOrNull(json['release_date']),
      runtimeInMinutes: json['runtime'] as int?,
      tagline: textOrNull(json['tagline']),
    );
  }

  static List<String> _genresFrom(Object? value) {
    if (value is! List) return const [];
    return value
        .whereType<Map<String, dynamic>>()
        .map((genre) => textOrNull(genre['name']))
        .nonNulls
        .toList();
  }

  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final List<String> genres;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final int? runtimeInMinutes;
  final String? tagline;
}
