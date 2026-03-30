import 'package:gyawun_metadata_plugin/src/plugin_api/metadata/models.dart';

class Artist {
  final String id;
  final String name;
  final String externalUri;
  final List<Image> images;
  final List<String>? genres;
  final int? followers;

  Artist({
    required this.id,
    required this.name,
    required this.externalUri,
    this.images = const [],
    this.genres,
    this.followers,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "externalUri": externalUri,
      "images": images.map((i) => i.toJson()).toList(),
      "genres": genres,
      "followers": followers,
    };
  }

  // fromJson
  factory Artist.fromJson(Map<String, dynamic> json) {
    if (json["id"] is! String) {
      throw Exception("Invalid Artist: id missing");
    }

    return Artist(
      id: json["id"],
      name: json["name"] ?? "",
      externalUri: json["externalUri"] ?? "",
      images: (json["images"] as List? ?? [])
          .map((i) => Image.fromJson(i))
          .toList(),
      genres: (json["genres"] as List?)?.map((g) => g.toString()).toList(),
      followers: json["followers"],
    );
  }
}
