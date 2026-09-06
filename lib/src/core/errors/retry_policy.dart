import 'package:cinetrack/src/core/errors/api_failure.dart';

const _maxRetries = 3;
const _firstDelay = Duration(milliseconds: 400);

Duration? retryNetworkFailures(int retryCount, Object error) {
  if (error is! NetworkFailure || retryCount >= _maxRetries) return null;
  return _firstDelay * (1 << retryCount);
}
