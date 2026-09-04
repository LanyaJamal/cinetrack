sealed class ApiFailure implements Exception {
  const ApiFailure();
}

/// No usable connection, or the request timed out.
final class NetworkFailure extends ApiFailure {
  const NetworkFailure();
}

/// The token is missing, wrong or revoked.
final class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure();
}

/// No movie with that id.
final class NotFoundFailure extends ApiFailure {
  const NotFoundFailure();
}

/// Tmdb answered, but not with a success.
final class ServerFailure extends ApiFailure {
  const ServerFailure(this.statusCode);

  final int statusCode;
}

/// The response arrived but was not the shape i expected.
final class ParseFailure extends ApiFailure {
  const ParseFailure();
}

/// Anything i did not plan for.
final class UnknownFailure extends ApiFailure {
  const UnknownFailure();
}
