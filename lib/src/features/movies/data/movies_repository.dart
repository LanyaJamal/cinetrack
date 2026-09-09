import 'package:cinetrack/src/core/errors/error_parser.dart';
import 'package:cinetrack/src/core/network/paginated.dart';
import 'package:cinetrack/src/core/utils/result.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_detail_model.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/data/movies_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MoviesRepository {
  Future<Result<Paginated<MovieModel>>> trending({int page = 1});

  Future<Result<Paginated<MovieModel>>> search(String query, {int page = 1});

  Future<Result<MovieDetailModel>> details(int id);

  Future<Result<Paginated<MovieModel>>> recommendations(int id);
}

class MoviesRepositoryImpl implements MoviesRepository {
  MoviesRepositoryImpl({required this.dataSource});

  final MoviesDataSource dataSource;

  @override
  Future<Result<Paginated<MovieModel>>> trending({int page = 1}) =>
      _guard(() => dataSource.trending(page: page));

  @override
  Future<Result<Paginated<MovieModel>>> search(String query, {int page = 1}) =>
      _guard(() => dataSource.search(query, page: page));

  @override
  Future<Result<MovieDetailModel>> details(int id) =>
      _guard(() => dataSource.details(id));

  @override
  Future<Result<Paginated<MovieModel>>> recommendations(int id) =>
      _guard(() => dataSource.recommendations(id));

  Future<Result<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Success(await request());
    } catch (error) {
      return Failure(parseError(error));
    }
  }
}

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepositoryImpl(dataSource: ref.watch(moviesDataSourceProvider));
});
