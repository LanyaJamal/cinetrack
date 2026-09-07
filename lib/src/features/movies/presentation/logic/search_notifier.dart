import 'dart:async';

import 'package:cinetrack/src/core/errors/retry_policy.dart';
import 'package:cinetrack/src/core/utils/result.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/data/movies_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _debounceDelay = Duration(milliseconds: 400);

class SearchQueryNotifier extends Notifier<String> {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  void update(String value) {
    final query = value.trim();
    _debounce?.cancel();
    if (query.isEmpty) {
      state = '';
      return;
    }
    _debounce = Timer(_debounceDelay, () => state = query);
  }

  void submit(String value) {
    _debounce?.cancel();
    state = value.trim();
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final searchResultsProvider = FutureProvider<List<MovieModel>>(
  (ref) async {
    final query = ref.watch(searchQueryProvider);
    if (query.isEmpty) return const [];
    final result = await ref.watch(moviesRepositoryProvider).search(query);
    return switch (result) {
      Success(:final value) => value.items,
      Failure(:final failure) => throw failure,
    };
  },
  isAutoDispose: true,
  retry: retryNetworkFailures,
);
