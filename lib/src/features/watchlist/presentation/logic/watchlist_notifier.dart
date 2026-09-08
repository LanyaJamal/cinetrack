import 'package:cinetrack/src/core/errors/api_failure.dart';
import 'package:cinetrack/src/core/utils/result.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/watchlist/data/watchlist_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistNotifier extends Notifier<List<MovieModel>> {
  @override
  List<MovieModel> build() {
    return switch (ref.watch(watchlistRepositoryProvider).load()) {
      Success(:final value) => value,
      Failure() => const [],
    };
  }

  bool contains(int movieId) => state.any((movie) => movie.id == movieId);

  Future<ApiFailure?> toggle(MovieModel movie) {
    final saved = contains(movie.id);
    return _apply(
      optimistic: saved
          ? [
              for (final entry in state)
                if (entry.id != movie.id) entry,
            ]
          : [movie, ...state],
      write: (repository) => repository.toggle(movie),
    );
  }

  Future<ApiFailure?> remove(MovieModel movie) {
    return _apply(
      optimistic: [
        for (final entry in state)
          if (entry.id != movie.id) entry,
      ],
      write: (repository) => repository.remove(movie),
    );
  }

  Future<ApiFailure?> restore(MovieModel movie, int index) {
    final next = [
      for (final entry in state)
        if (entry.id != movie.id) entry,
    ]..insert(index.clamp(0, state.length), movie);
    return _apply(
      optimistic: next,
      write: (repository) => repository.restore(movie, index),
    );
  }

  Future<ApiFailure?> _apply({
    required List<MovieModel> optimistic,
    required Future<Result<List<MovieModel>>> Function(
      WatchlistRepository repository,
    )
    write,
  }) async {
    final previous = state;
    state = optimistic;
    final result = await write(ref.read(watchlistRepositoryProvider));
    switch (result) {
      case Success(:final value):
        state = value;
        return null;
      case Failure(:final failure):
        state = previous;
        return failure;
    }
  }
}

final watchlistProvider = NotifierProvider<WatchlistNotifier, List<MovieModel>>(
  WatchlistNotifier.new,
);
