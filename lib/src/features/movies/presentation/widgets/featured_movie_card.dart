import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/src/core/api/tmdb_image.dart';
import 'package:cinetrack/src/core/helpers/format_extensions.dart';
import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:flutter/material.dart';

class FeaturedMovieCard extends StatelessWidget {
  const FeaturedMovieCard({super.key, required this.movie, this.onTap});

  final MovieModel movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl =
        TmdbImage.backdrop(movie.backdropPath) ??
        TmdbImage.poster(movie.posterPath, size: PosterSize.w500);
    final rating = movie.voteAverage.ratingLabel;
    final year = movie.releaseDate.yearLabel;
    final metaStyle = theme.textTheme.labelLarge?.copyWith(
      color: Colors.white.withValues(alpha: 0.86),
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: ClipRSuperellipse(
          borderRadius: AppShape.largeRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _FeaturedImage(url: imageUrl),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.3, 1],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RankChip(
                      color: theme.colorScheme.primary,
                      onColor: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
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
                              style: metaStyle?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                          if (rating.isNotEmpty && year.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text('·', style: metaStyle),
                            ),
                          if (year.isNotEmpty) Text(year, style: metaStyle),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: Colors.white.withValues(alpha: 0.08),
                    highlightColor: Colors.white.withValues(alpha: 0.06),
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

class _RankChip extends StatelessWidget {
  const _RankChip({required this.color, required this.onColor});

  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(color: color, shape: AppShape.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          '#1 TODAY',
          style: TextStyle(
            color: onColor,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _FeaturedImage extends StatelessWidget {
  const _FeaturedImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fallback = ColoredBox(
      color: colors.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          size: 36,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
    final imageUrl = url;
    if (imageUrl == null) return fallback;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 240),
      fadeInCurve: Curves.easeOut,
      placeholder: (context, url) =>
          ColoredBox(color: colors.surfaceContainerHigh),
      errorWidget: (context, url, error) => fallback,
    );
  }
}
