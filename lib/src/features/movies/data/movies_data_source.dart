import 'package:cinetrack/src/core/api/api.dart';
import 'package:cinetrack/src/core/network/api_client.dart';
import 'package:cinetrack/src/core/network/paginated.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_detail_model.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MoviesDataSource {
  Future<Paginated<MovieModel>> trending({int page = 1});

  Future<Paginated<MovieModel>> search(String query, {int page = 1});

  Future<MovieDetailModel> details(int id);

  Future<Paginated<MovieModel>> recommendations(int id);
}

class MoviesDataSourceImpl implements MoviesDataSource {
  MoviesDataSourceImpl({required this.client});

  final ApiClient client;

  @override
  Future<Paginated<MovieModel>> trending({int page = 1}) async {
    final json = await client.get(Api.trendingMovies, query: {'page': '$page'});
    return Paginated.fromJson(json, MovieModel.fromJson);
  }

  @override
  Future<Paginated<MovieModel>> search(String query, {int page = 1}) async {
    final json = await client.get(
      Api.searchMovies,
      query: {'query': query, 'page': '$page', 'include_adult': 'false'},
    );
    return Paginated.fromJson(json, MovieModel.fromJson);
  }

  @override
  Future<MovieDetailModel> details(int id) async {
    final json = await client.get(Api.movieDetails(id));
    return MovieDetailModel.fromJson(json);
  }

  @override
  Future<Paginated<MovieModel>> recommendations(int id) async {
    final json = await client.get(Api.movieRecommendations(id));
    return Paginated.fromJson(json, MovieModel.fromJson);
  }
}

final moviesDataSourceProvider = Provider<MoviesDataSource>((ref) {
  return MoviesDataSourceImpl(client: ref.watch(apiClientProvider));
});
