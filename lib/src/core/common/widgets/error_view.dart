import 'package:cinetrack/src/core/errors/api_failure.dart';
import 'package:cinetrack/src/core/errors/error_parser.dart';
import 'package:cinetrack/src/core/theme/app_shape.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, title, message) = _describe(parseError(error));
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                shape: AppShape.large,
              ),
              child: Icon(
                icon,
                size: 30,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }

  (IconData, String, String) _describe(ApiFailure failure) {
    return switch (failure) {
      NetworkFailure() => (
        Icons.wifi_off_rounded,
        "You're offline",
        'Check your connection, then try again.',
      ),
      UnauthorizedFailure() => (
        Icons.lock_outline_rounded,
        'Access refused',
        'TMDB rejected the access token this app was built with.',
      ),
      NotFoundFailure() => (
        Icons.search_off_rounded,
        'Not found',
        'TMDB has nothing at that address.',
      ),
      ServerFailure(:final statusCode) => (
        Icons.cloud_off_rounded,
        'TMDB is having trouble',
        'The service answered with $statusCode. Give it a moment.',
      ),
      ParseFailure() => (
        Icons.report_outlined,
        'Unexpected answer',
        'TMDB sent something this app could not read.',
      ),
      UnknownFailure() => (
        Icons.error_outline_rounded,
        'Something went wrong',
        'That did not work. Try again.',
      ),
    };
  }
}
