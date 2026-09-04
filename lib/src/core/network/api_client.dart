import 'dart:convert';

import 'package:cinetrack/src/core/api/api.dart';
import 'package:cinetrack/src/core/constants/env_config.dart';
import 'package:cinetrack/src/core/errors/api_failure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const Duration _timeout = Duration(seconds: 15);

  final http.Client _client;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
  }) async {
    if (!EnvConfig.hasTmdbAccessToken) throw const UnauthorizedFailure();

    final uri = Uri.parse(
      '${Api.baseUrl}$path',
    ).replace(queryParameters: query);

    final response = await _client
        .get(
          uri,
          headers: const {
            'Authorization': 'Bearer ${EnvConfig.tmdbAccessToken}',
            'Accept': 'application/json',
          },
        )
        .timeout(_timeout);

    if (response.statusCode == 200) return _decode(response.body);

    throw switch (response.statusCode) {
      401 || 403 => const UnauthorizedFailure(),
      404 => const NotFoundFailure(),
      final code => ServerFailure(code),
    };
  }

  Map<String, dynamic> _decode(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) throw const ParseFailure();
    return decoded;
  }

  void close() => _client.close();
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient();
  ref.onDispose(client.close);
  return client;
});
