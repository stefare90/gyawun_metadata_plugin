import 'package:gyawun_metadata_plugin/src/plugin_api/metadata/models.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String externalUri;
  final User owner;
  final List<Image> images;
  final List<User> collaborators;
  final bool collaborative;
  final bool isPublic;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.externalUri,
    required this.owner,
    this.images = const [],
    this.collaborators = const [],
    this.collaborative = false,
    this.isPublic = false,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "externalUri": externalUri,
      "owner": owner.toJson(),
      "images": images.map((i) => i.toJson()).toList(),
      "collaborators": collaborators.map((u) => u.toJson()).toList(),
      "collaborative": collaborative,
      "public": isPublic,
    };
  }

  // fromJson
  factory Playlist.fromJson(Map<String, dynamic> json) {
    if (json["id"] is! String) {
      throw Exception("Invalid Playlist: id missing");
    }

    return Playlist(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      externalUri: json["externalUri"] ?? "",
      owner: User.fromJson(json["owner"] ?? {}),
      images: (json["images"] as List? ?? [])
          .map((i) => Image.fromJson(i))
          .toList(),
      collaborators: (json["collaborators"] as List? ?? [])
          .map((u) => User.fromJson(u))
          .toList(),
      collaborative: json["collaborative"] ?? false,
      isPublic: json["public"] ?? false,
    );
  }
}
