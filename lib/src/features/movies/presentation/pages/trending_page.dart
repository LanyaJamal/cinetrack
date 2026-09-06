import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:cinetrack/src/core/common/widgets/error_view.dart';
import 'package:cinetrack/src/core/common/widgets/loading_view.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/presentation/logic/trending_notifier.dart';
import 'package:cinetrack/src/features/movies/presentation/widgets/movie_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingPage extends ConsumerWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(trendingProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Trending')),
      body: SafeArea(
        top: false,
        child: switch (feed) {
          AsyncValue(isLoading: true, hasValue: false) => const LoadingView(),
          AsyncData(:final value) =>
            value.movies.isEmpty
                ? const EmptyView(
                    icon: Icons.local_fire_department_outlined,
                    title: 'Nothing trending yet',
                    message: 'TMDB has no trending titles for today.',
                  )
                : _TrendingList(movies: value.movies),
          AsyncError(:final error) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(trendingProvider),
          ),
          _ => const LoadingView(),
        },
      ),
    );
  }
}

class _TrendingList extends StatelessWidget {
  const _TrendingList({required this.movies});

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      itemCount: movies.length,
      itemBuilder: (context, index) => MovieListTile(movie: movies[index]),
    );
  }
}
