import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/src/app/routes.dart';
import 'package:cinetrack/src/core/api/tmdb_image.dart';
import 'package:cinetrack/src/core/common/widgets/poster_image.dart';
import 'package:cinetrack/src/core/errors/error_parser.dart';
import 'package:cinetrack/src/core/errors/failure_copy.dart';
import 'package:cinetrack/src/core/helpers/format_extensions.dart';
import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:cinetrack/src/core/theme/app_theme.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_detail_model.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/movies/presentation/logic/movie_detail_provider.dart';
import 'package:cinetrack/src/features/watchlist/presentation/widgets/watchlist_toggle_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.heroTag,
  });

  final MovieModel movie;
  final String heroTag;

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  static const double _collapseDistance = 190;

  late final ScrollController _controller;
  double _collapse = 0;
  double _scroll = 0;

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
    final offset = _controller.offset;
    final next = (offset / _collapseDistance).clamp(0.0, 1.0);
    if ((offset - _scroll).abs() < 1 && (next - _collapse).abs() < 0.01) {
      return;
    }
    setState(() {
      _scroll = offset;
      _collapse = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final detail = ref.watch(movieDetailProvider(movie.id));
    final scheme = Theme.of(context).colorScheme;
    final overImage = _collapse < 0.5;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overImage
          ? AppTheme.overlayStyleFor(scheme).copyWith(
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
            )
          : AppTheme.overlayStyleFor(scheme),
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              controller: _controller,
              padding: EdgeInsets.only(
                bottom: 32 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                _Backdrop(movie: movie, scroll: _scroll),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TitleBlock(movie: movie, heroTag: widget.heroTag),
                      _DetailSection(movie: movie, detail: detail),
                    ],
                  ),
                ),
                _MoreLikeThis(movieId: movie.id),
              ],
            ),
            _CollapsingBar(progress: _collapse, title: movie.title),
          ],
        ),
      ),
    );
  }
}

class _CollapsingBar extends StatelessWidget {
  const _CollapsingBar({required this.progress, required this.title});

  final double progress;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insets = MediaQuery.paddingOf(context);
    return SizedBox(
      height: insets.top + kToolbarHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: progress),
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(
                alpha: progress,
              ),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: insets.top,
            left: 8 + insets.left,
            right: 16 + insets.right,
          ),
          child: Row(
            children: [
              _BackButton(progress: progress),
              const SizedBox(width: 8),
              Expanded(
                child: Opacity(
                  opacity: progress,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.black.withValues(alpha: 0.32 * (1 - progress)),
      ),
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Back',
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Color.lerp(
            Colors.white,
            theme.colorScheme.onSurface,
            progress,
          ),
        ),
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.movie, required this.scroll});

  static const double _height = 260;
  static const double _travel = 72;

  final MovieModel movie;
  final double scroll;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final url =
        TmdbImage.backdrop(movie.backdropPath) ??
        TmdbImage.poster(movie.posterPath, size: PosterSize.w500);
    final shift = (scroll * 0.4).clamp(0.0, _travel);
    return ClipRect(
      child: SizedBox(
        height: _height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            OverflowBox(
              alignment: Alignment.bottomCenter,
              maxHeight: _height + _travel,
              child: Transform.translate(
                offset: Offset(0, shift),
                child: SizedBox(
                  height: _height + _travel,
                  child: url == null
                      ? ColoredBox(color: colors.surfaceContainerHigh)
                      : CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 240),
                          fadeInCurve: Curves.easeOut,
                          placeholder: (context, url) =>
                              ColoredBox(color: colors.surfaceContainerHigh),
                          errorWidget: (context, url, error) =>
                              ColoredBox(color: colors.surfaceContainerHigh),
                        ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.45, 1],
                  colors: [Colors.transparent, colors.surface],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.movie, required this.heroTag});

  final MovieModel movie;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = movie.voteAverage.ratingLabel;
    final year = movie.releaseDate.yearLabel;
    return Transform.translate(
      offset: const Offset(0, -46),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PosterImage(
              path: movie.posterPath,
              width: 104,
              height: 156,
              heroTag: heroTag,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        height: 1.15,
                      ),
                    ),
                    if (rating.isNotEmpty || year.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (rating.isNotEmpty) ...[
                            Icon(
                              Icons.star_rounded,
                              size: 17,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                          if (rating.isNotEmpty && year.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '·',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          if (year.isNotEmpty)
                            Text(
                              year,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends ConsumerWidget {
  const _DetailSection({required this.movie, required this.detail});

  final MovieModel movie;
  final AsyncValue<MovieDetailModel> detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Transform.translate(
      offset: const Offset(0, -34),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switch (detail) {
              AsyncData(:final value) => _DetailFacts(detail: value),
              AsyncError(:final error) => _DetailUnavailable(
                error: error,
                onRetry: () => ref.invalidate(movieDetailProvider(movie.id)),
              ),
              _ => const _FactsPlaceholder(),
            },
            const SizedBox(height: 22),
            WatchlistToggleButton(movie: movie),
            if (movie.overview.isNotEmpty) ...[
              const SizedBox(height: 26),
              Text(
                'Overview',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                movie.overview,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailFacts extends StatelessWidget {
  const _DetailFacts({required this.detail});

  final MovieDetailModel detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final runtime = detail.runtimeInMinutes.runtimeLabel;
    final tagline = detail.tagline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (tagline != null) ...[
          Text(
            tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (detail.genres.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final genre in detail.genres) _GenreChip(label: genre),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            if (runtime.isNotEmpty) ...[
              _Fact(icon: Icons.schedule_rounded, label: runtime),
              const SizedBox(width: 18),
            ],
            if (detail.voteCount > 0)
              _Fact(
                icon: Icons.people_alt_outlined,
                label: '${detail.voteCount.compactLabel} votes',
              ),
          ],
        ),
      ],
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: AppShape.small,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FactsPlaceholder extends StatelessWidget {
  const _FactsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 34,
      child: Align(
        alignment: Alignment.centerLeft,
        child: CupertinoActivityIndicator(radius: 9),
      ),
    );
  }
}

class _DetailUnavailable extends StatelessWidget {
  const _DetailUnavailable({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            describeFailure(parseError(error)).title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}

class _MoreLikeThis extends ConsumerWidget {
  const _MoreLikeThis({required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final related = ref.watch(movieRecommendationsProvider(movieId));
    return Transform.translate(
      offset: const Offset(0, -34),
      child: switch (related) {
        AsyncData(:final value) when value.isEmpty => const SizedBox.shrink(),
        AsyncData(:final value) => _RelatedRow(movies: value),
        AsyncError() => const SizedBox.shrink(),
        _ => const _RelatedRow(movies: null),
      },
    );
  }
}

class _RelatedRow extends StatelessWidget {
  const _RelatedRow({required this.movies});

  static const double _posterWidth = 104;
  static const double _posterHeight = 156;

  final List<MovieModel>? movies;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insets = MediaQuery.paddingOf(context);
    final items = movies;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            20 + insets.left,
            30,
            20 + insets.right,
            12,
          ),
          child: Text(
            'More like this',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          height: _posterHeight + 6 + 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(
              20 + insets.left,
              0,
              8 + insets.right,
              0,
            ),
            itemCount: items?.length ?? 4,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: items == null
                  ? const _RelatedPlaceholder(
                      width: _posterWidth,
                      height: _posterHeight,
                    )
                  : _RelatedCard(
                      movie: items[index],
                      width: _posterWidth,
                      height: _posterHeight,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({
    required this.movie,
    required this.width,
    required this.height,
  });

  final MovieModel movie;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heroTag = 'related-${movie.id}';
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).push(movieDetailRoute(movie, heroTag: heroTag)),
        customBorder: AppShape.small,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosterImage(
              path: movie.posterPath,
              width: width,
              height: height,
              heroTag: heroTag,
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RelatedPlaceholder extends StatelessWidget {
  const _RelatedPlaceholder({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHigh;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            child: DecoratedBox(
              decoration: ShapeDecoration(color: color, shape: AppShape.small),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: width * 0.7,
            height: 11,
            child: DecoratedBox(
              decoration: ShapeDecoration(color: color, shape: AppShape.small),
            ),
          ),
        ],
      ),
    );
  }
}
