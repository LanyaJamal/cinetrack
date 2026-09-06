extension ReleaseYearLabel on DateTime? {
  String get yearLabel {
    final date = this;
    return date == null ? '' : '${date.year}';
  }
}

extension RatingLabel on double {
  String get ratingLabel => this <= 0 ? '' : toStringAsFixed(1);
}
