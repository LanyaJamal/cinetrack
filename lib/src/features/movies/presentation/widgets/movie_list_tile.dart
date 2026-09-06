import 'package:cinetrack/src/core/common/widgets/poster_image.dart';
import 'package:cinetrack/src/core/helpers/format_extensions.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieListTile extends StatelessWidget {
  const MovieListTile({super.key, required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PosterImage(path: movie.posterPath),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),
                _MovieMeta(movie: movie),
                if (movie.overview.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieMeta extends StatelessWidget {
  const _MovieMeta({required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rating = movie.voteAverage.ratingLabel;
    final year = movie.releaseDate.yearLabel;
    final labelStyle = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Row(
      children: [
        if (rating.isNotEmpty) ...[
          Icon(Icons.star_rounded, size: 15, color: theme.colorScheme.primary),
          const SizedBox(width: 3),
          Text(
            rating,
            style: labelStyle?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (rating.isNotEmpty && year.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Text('·', style: labelStyle),
          ),
        if (year.isNotEmpty) Text(year, style: labelStyle),
      ],
    );
  }
}
