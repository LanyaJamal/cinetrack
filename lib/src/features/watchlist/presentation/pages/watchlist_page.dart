import 'package:cinetrack/src/app/routes.dart';
import 'package:cinetrack/src/core/common/widgets/empty_view.dart';
import 'package:cinetrack/src/core/errors/failure_copy.dart';
import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/presentation/widgets/movie_list_tile.dart';
import 'package:cinetrack/src/features/watchlist/presentation/logic/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistPage extends ConsumerWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(watchlistProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: SafeArea(
        top: false,
        child: movies.isEmpty
            ? const EmptyView(
                icon: Icons.bookmark_outline,
                title: 'Your watchlist is empty',
                message:
                    'Movies you save are kept on this device, even offline.',
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: movies.length,
                itemBuilder: (context, index) =>
                    _WatchlistRow(movie: movies[index], index: index),
              ),
      ),
    );
  }
}

class _WatchlistRow extends ConsumerWidget {
  const _WatchlistRow({required this.movie, required this.index});

  final MovieModel movie;
  final int index;

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(watchlistProvider.notifier);
    final failure = await notifier.remove(movie);
    messenger.hideCurrentSnackBar();
    if (failure != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(describeFailure(failure).title)),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text('Removed ${movie.title}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => notifier.restore(movie, index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final heroTag = 'watchlist-${movie.id}';
    return Dismissible(
      key: ValueKey(movie.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _remove(context, ref),
      background: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: theme.colorScheme.errorContainer,
            shape: AppShape.medium,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 22),
              child: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ),
      ),
      child: MovieListTile(
        movie: movie,
        heroTag: heroTag,
        onTap: () => Navigator.of(
          context,
        ).push(movieDetailRoute(movie, heroTag: heroTag)),
      ),
    );
  }
}
