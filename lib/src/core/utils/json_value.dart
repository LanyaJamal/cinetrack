DateTime? dateOrNull(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

String? textOrNull(Object? value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String textOrEmpty(Object? value) => value is String ? value : '';

double doubleOrZero(Object? value) => value is num ? value.toDouble() : 0;
