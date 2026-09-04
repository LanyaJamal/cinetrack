class Paginated<T> {
  const Paginated({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final results = json['results'];
    return Paginated(
      items: results is List
          ? results.whereType<Map<String, dynamic>>().map(itemFromJson).toList()
          : const [],
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 0,
    );
  }

  final List<T> items;
  final int page;
  final int totalPages;

  bool get hasMore => page < totalPages;
}
