import 'package:cinetrack/src/core/utils/json_value.dart';

class MovieModel {
  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: textOrEmpty(json['title']),
      overview: textOrEmpty(json['overview']),
      voteAverage: doubleOrZero(json['vote_average']),
      posterPath: textOrNull(json['poster_path']),
      backdropPath: textOrNull(json['backdrop_path']),
      releaseDate: dateOrNull(json['release_date']),
    );
  }

  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'overview': overview,
    'vote_average': voteAverage,
    'poster_path': posterPath,
    'backdrop_path': backdropPath,
    'release_date': releaseDate?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) => other is MovieModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
