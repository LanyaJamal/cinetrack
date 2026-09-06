import 'package:cinetrack/src/core/errors/api_failure.dart';
import 'package:flutter/material.dart';

typedef FailureCopy = ({IconData icon, String title, String message});

FailureCopy describeFailure(ApiFailure failure) {
  return switch (failure) {
    NetworkFailure() => (
      icon: Icons.wifi_off_rounded,
      title: "You're offline",
      message: 'Check your connection, then try again.',
    ),
    UnauthorizedFailure() => (
      icon: Icons.lock_outline_rounded,
      title: 'Access refused',
      message: 'TMDB rejected the access token this app was built with.',
    ),
    NotFoundFailure() => (
      icon: Icons.search_off_rounded,
      title: 'Not found',
      message: 'TMDB has nothing at that address.',
    ),
    ServerFailure(:final statusCode) => (
      icon: Icons.cloud_off_rounded,
      title: 'TMDB is having trouble',
      message: 'The service answered with $statusCode. Give it a moment.',
    ),
    ParseFailure() => (
      icon: Icons.report_outlined,
      title: 'Unexpected answer',
      message: 'TMDB sent something this app could not read.',
    ),
    UnknownFailure() => (
      icon: Icons.error_outline_rounded,
      title: 'Something went wrong',
      message: 'That did not work. Try again.',
    ),
  };
}
