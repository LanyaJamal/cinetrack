import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/src/core/api/tmdb_image.dart';
import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:flutter/material.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.path,
    this.width = 64,
    this.height = 96,
  });

  final String? path;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final url = TmdbImage.poster(path, size: PosterSize.w185);
    return ClipRSuperellipse(
      borderRadius: AppShape.smallRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: url == null
            ? _Placeholder(colors: colors, showIcon: true)
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 200),
                fadeInCurve: Curves.easeOut,
                placeholder: (context, url) => _Placeholder(colors: colors),
                errorWidget: (context, url, error) =>
                    _Placeholder(colors: colors, showIcon: true),
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.colors, this.showIcon = false});

  final ColorScheme colors;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: colors.surfaceContainerHigh,
      child: showIcon
          ? Center(
              child: Icon(
                Icons.movie_outlined,
                size: 22,
                color: colors.onSurfaceVariant,
              ),
            )
          : null,
    );
  }
}
