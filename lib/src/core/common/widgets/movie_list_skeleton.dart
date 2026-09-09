import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:flutter/material.dart';

class MovieListSkeleton extends StatefulWidget {
  const MovieListSkeleton({super.key, this.featured = false, this.rows = 6});

  final bool featured;
  final int rows;

  @override
  State<MovieListSkeleton> createState() => _MovieListSkeletonState();
}

class _MovieListSkeletonState extends State<MovieListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
      lowerBound: 0.45,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _pulse,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: widget.featured ? 0 : 4),
        children: [
          if (widget.featured) const _FeaturedBlock(),
          for (var i = 0; i < widget.rows; i++) const _RowBlock(),
        ],
      ),
    );
  }
}

class _FeaturedBlock extends StatelessWidget {
  const _FeaturedBlock();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 6, 20, 14),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: _Block(shape: AppShape.large),
      ),
    );
  }
}

class _RowBlock extends StatelessWidget {
  const _RowBlock();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Block(width: 64, height: 96),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                _Line(widthFactor: 0.72, height: 15),
                SizedBox(height: 9),
                _Line(widthFactor: 0.34, height: 11),
                SizedBox(height: 12),
                _Line(widthFactor: 1, height: 10),
                SizedBox(height: 6),
                _Line(widthFactor: 0.86, height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.widthFactor, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: _Block(height: height),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({this.width, this.height, this.shape = AppShape.small});

  final double? width;
  final double? height;
  final RoundedSuperellipseBorder shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          shape: shape,
        ),
      ),
    );
  }
}
