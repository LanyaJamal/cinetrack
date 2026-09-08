extension ReleaseYearLabel on DateTime? {
  String get yearLabel {
    final date = this;
    return date == null ? '' : '${date.year}';
  }
}

extension RatingLabel on double {
  String get ratingLabel => this <= 0 ? '' : toStringAsFixed(1);
}

extension RuntimeLabel on int? {
  String get runtimeLabel {
    final minutes = this;
    if (minutes == null || minutes <= 0) return '';
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    if (hours == 0) return '${remainder}m';
    if (remainder == 0) return '${hours}h';
    return '${hours}h ${remainder}m';
  }
}

extension CompactCountLabel on int {
  String get compactLabel {
    if (this >= 1000000) return '${_trimmed(this / 1000000)}M';
    if (this >= 1000) return '${_trimmed(this / 1000)}k';
    return '$this';
  }

  String _trimmed(double value) {
    final text = value.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }
}
