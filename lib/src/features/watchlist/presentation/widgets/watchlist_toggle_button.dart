import 'dart:async';

import 'package:cinetrack/src/core/errors/failure_copy.dart';
import 'package:cinetrack/src/features/movies/data/models/movie_model.dart';
import 'package:cinetrack/src/features/watchlist/presentation/logic/watchlist_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WatchlistToggleButton extends ConsumerStatefulWidget {
  const WatchlistToggleButton({super.key, required this.movie});

  final MovieModel movie;

  @override
  ConsumerState<WatchlistToggleButton> createState() =>
      _WatchlistToggleButtonState();
}

class _WatchlistToggleButtonState extends ConsumerState<WatchlistToggleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.9,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 65,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    unawaited(HapticFeedback.selectionClick());
    unawaited(_controller.forward(from: 0));
    final failure = await ref
        .read(watchlistProvider.notifier)
        .toggle(widget.movie);
    if (failure == null || !mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(describeFailure(failure).title)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saved = ref.watch(
      watchlistProvider.select(
        (movies) => movies.any((movie) => movie.id == widget.movie.id),
      ),
    );
    return ScaleTransition(
      scale: _scale,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: _toggle,
          style: saved
              ? FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  foregroundColor: theme.colorScheme.onSurface,
                )
              : null,
          icon: Icon(
            saved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
            size: 19,
          ),
          label: Text(saved ? 'In watchlist' : 'Add to watchlist'),
        ),
      ),
    );
  }
}
