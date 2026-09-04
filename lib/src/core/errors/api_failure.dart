sealed class ApiFailure implements Exception {
  const ApiFailure();
}

final class NetworkFailure extends ApiFailure {
  const NetworkFailure();
}

final class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure();
}

final class NotFoundFailure extends ApiFailure {
  const NotFoundFailure();
}

final class ServerFailure extends ApiFailure {
  const ServerFailure(this.statusCode);

  final int statusCode;
}

final class ParseFailure extends ApiFailure {
  const ParseFailure();
}

final class UnknownFailure extends ApiFailure {
  const UnknownFailure();
}
