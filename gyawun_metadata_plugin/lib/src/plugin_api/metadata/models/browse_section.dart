class BrowseSection<T> {
  final String id;
  final String title;
  final String externalUri;
  final bool browseMore;
  final List<T> items;

  BrowseSection({
    required this.id,
    required this.title,
    required this.externalUri,
    required this.browseMore,
    required this.items,
  });

  // toJson
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T item) toJsonT) {
    return {
      "id": id,
      "title": title,
      "externalUri": externalUri,
      "browseMore": browseMore,
      "items": items.map(toJsonT).toList(),
    };
  }

  // fromJson
  factory BrowseSection.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return BrowseSection<T>(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      externalUri: json["externalUri"] ?? "",
      browseMore: json["browseMore"] ?? false,
      items: (json["items"] as List? ?? [])
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
