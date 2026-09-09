import 'package:cinetrack/src/core/errors/retry_policy.dart';
import 'package:cinetrack/src/core/utils/result.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_detail_model.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/data/movies_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieDetailProvider = FutureProvider.family<MovieDetailModel, int>(
  (ref, id) async {
    final result = await ref.watch(moviesRepositoryProvider).details(id);
    return switch (result) {
      Success(:final value) => value,
      Failure(:final failure) => throw failure,
    };
  },
  isAutoDispose: true,
  retry: retryNetworkFailures,
);

final movieRecommendationsProvider =
    FutureProvider.family<List<MovieModel>, int>(
      (ref, id) async {
        final result = await ref
            .watch(moviesRepositoryProvider)
            .recommendations(id);
        return switch (result) {
          Success(:final value) => value.items,
          Failure(:final failure) => throw failure,
        };
      },
      isAutoDispose: true,
      retry: retryNetworkFailures,
    );
