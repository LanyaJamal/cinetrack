import 'package:cinetrack/src/core/errors/api_failure.dart';
import 'package:cinetrack/src/core/errors/error_parser.dart';
import 'package:cinetrack/src/core/errors/retry_policy.dart';
import 'package:cinetrack/src/core/network/paginated.dart';
import 'package:cinetrack/src/core/utils/result.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/data/movies_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingFeed {
  const TrendingFeed({
    required this.movies,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  static const empty = TrendingFeed(movies: [], page: 0, hasMore: true);

  final List<MovieModel> movies;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final ApiFailure? loadMoreFailure;

  TrendingFeed followedBy(Paginated<MovieModel> next) {
    final known = movies.map((movie) => movie.id).toSet();
    return TrendingFeed(
      movies: [...movies, ...next.items.where((movie) => known.add(movie.id))],
      page: next.page,
      hasMore: next.hasMore,
    );
  }

  TrendingFeed loadingMore() => TrendingFeed(
    movies: movies,
    page: page,
    hasMore: hasMore,
    isLoadingMore: true,
  );

  TrendingFeed unableToLoadMore(ApiFailure failure) => TrendingFeed(
    movies: movies,
    page: page,
    hasMore: hasMore,
    loadMoreFailure: failure,
  );
}

class TrendingNotifier extends AsyncNotifier<TrendingFeed> {
  late MoviesRepository _repository;
  bool _isFetching = false;

  @override
  Future<TrendingFeed> build() {
    _repository = ref.watch(moviesRepositoryProvider);
    return _fetchAfter(TrendingFeed.empty);
  }

  Future<ApiFailure?> refresh() async {
    if (_isFetching) return null;
    final previous = state;
    final next = await AsyncValue.guard(() => _fetchAfter(TrendingFeed.empty));
    if (next case AsyncError(:final error) when previous.hasValue) {
      return parseError(error);
    }
    state = next;
    return null;
  }

  Future<void> loadMore() async {
    final feed = state.value;
    if (feed == null || !feed.hasMore || _isFetching) return;
    state = AsyncData(feed.loadingMore());
    try {
      state = AsyncData(await _fetchAfter(feed));
    } on ApiFailure catch (failure) {
      state = AsyncData(feed.unableToLoadMore(failure));
    }
  }

  Future<TrendingFeed> _fetchAfter(TrendingFeed feed) async {
    _isFetching = true;
    try {
      final result = await _repository.trending(page: feed.page + 1);
      return switch (result) {
        Success(:final value) => feed.followedBy(value),
        Failure(:final failure) => throw failure,
      };
    } finally {
      _isFetching = false;
    }
  }
}

final trendingProvider = AsyncNotifierProvider<TrendingNotifier, TrendingFeed>(
  TrendingNotifier.new,
  retry: retryNetworkFailures,
);
