import 'dart:async';
import 'dart:io';

import 'package:cinetrack/src/core/errors/api_failure.dart';
import 'package:http/http.dart';

ApiFailure parseError(Object error) {
  return switch (error) {
    final ApiFailure failure => failure,
    ClientException() ||
    IOException() ||
    TimeoutException() => const NetworkFailure(),
    FormatException() || TypeError() => const ParseFailure(),
    _ => const UnknownFailure(),
  };
}
