import 'package:gyawun_metadata_plugin/src/plugin_api/metadata/models.dart';

class User {
  final String id;
  final String name;
  final List<Image> images;
  final String externalUri;

  User({
    required this.id,
    required this.name,
    this.images = const [],
    required this.externalUri,
  });

  // 🔹 toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "images": images.map((i) => i.toJson()).toList(),
      "externalUri": externalUri,
    };
  }

  // 🔹 fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    if (json["id"] is! String) {
      throw Exception("Invalid User: id missing");
    }

    return User(
      id: json["id"],
      name: json["name"] ?? "",
      images: (json["images"] as List? ?? [])
          .map((i) => Image.fromJson(i))
          .toList(),
      externalUri: json["externalUri"] ?? "",
    );
  }
}
