import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:cinetrack/src/core/common/widgets/error_view.dart';
import 'package:cinetrack/src/core/common/widgets/loading_view.dart';
import 'package:cinetrack/src/core/errors/failure_copy.dart';
import 'package:cinetrack/src/features/movies/presentation/logic/trending_notifier.dart';
import 'package:cinetrack/src/features/movies/presentation/widgets/movie_list_tile.dart';
import 'package:flutter/cupertino.dart';
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
                : _TrendingList(feed: value),
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

class _TrendingList extends ConsumerStatefulWidget {
  const _TrendingList({required this.feed});

  final TrendingFeed feed;

  @override
  ConsumerState<_TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends ConsumerState<_TrendingList> {
  static const double _loadMoreThreshold = 400;

  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    final feed = widget.feed;
    if (!feed.hasMore || feed.loadMoreFailure != null) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - _loadMoreThreshold) {
      ref.read(trendingProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    final failure = await ref.read(trendingProvider.notifier).refresh();
    if (failure == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(describeFailure(failure).title)));
  }

  @override
  Widget build(BuildContext context) {
    final movies = widget.feed.movies;
    return RefreshIndicator.adaptive(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 4, bottom: 16),
        itemCount: movies.length + 1,
        itemBuilder: (context, index) => index == movies.length
            ? _ListFooter(feed: widget.feed)
            : MovieListTile(movie: movies[index]),
      ),
    );
  }
}

class _ListFooter extends ConsumerWidget {
  const _ListFooter({required this.feed});

  final TrendingFeed feed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final failure = feed.loadMoreFailure;

    if (failure != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            Text(
              describeFailure(failure).title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => ref.read(trendingProvider.notifier).loadMore(),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (feed.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    if (!feed.hasMore) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Text(
          "That's everything trending today",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return const SizedBox(height: 8);
  }
}
