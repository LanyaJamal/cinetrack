import 'package:cinetrack/src/core/errors/error_parser.dart';
import 'package:cinetrack/src/core/utils/result.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/watchlist/data/watchlist_local_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class WatchlistRepository {
  Result<List<MovieModel>> load();

  Future<Result<List<MovieModel>>> toggle(MovieModel movie);

  Future<Result<List<MovieModel>>> remove(MovieModel movie);

  Future<Result<List<MovieModel>>> restore(MovieModel movie, int index);
}

class WatchlistRepositoryImpl implements WatchlistRepository {
  WatchlistRepositoryImpl({required this.dataSource});

  final WatchlistLocalDataSource dataSource;

  @override
  Result<List<MovieModel>> load() {
    try {
      return Success(dataSource.readAll());
    } catch (error) {
      return Failure(parseError(error));
    }
  }

  @override
  Future<Result<List<MovieModel>>> toggle(MovieModel movie) {
    return _write((current) {
      return current.any((saved) => saved.id == movie.id)
          ? _without(current, movie)
          : [movie, ...current];
    });
  }

  @override
  Future<Result<List<MovieModel>>> remove(MovieModel movie) {
    return _write((current) => _without(current, movie));
  }

  @override
  Future<Result<List<MovieModel>>> restore(MovieModel movie, int index) {
    return _write((current) {
      final next = _without(current, movie);
      next.insert(index.clamp(0, next.length), movie);
      return next;
    });
  }

  Future<Result<List<MovieModel>>> _write(
    List<MovieModel> Function(List<MovieModel> current) change,
  ) async {
    try {
      final next = change(dataSource.readAll());
      await dataSource.writeAll(next);
      return Success(next);
    } catch (error) {
      return Failure(parseError(error));
    }
  }

  List<MovieModel> _without(List<MovieModel> movies, MovieModel movie) {
    return [
      for (final saved in movies)
        if (saved.id != movie.id) saved,
    ];
  }
}

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepositoryImpl(
    dataSource: ref.watch(watchlistLocalDataSourceProvider),
  );
});
