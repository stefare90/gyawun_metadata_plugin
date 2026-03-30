import 'package:gyawun_metadata_plugin/src/plugin_api/metadata/models.dart';

enum AlbumType { album, single, compilation }

class Album {
  final String id;
  final String name;
  final List<Artist> artists;
  final List<Image> images;
  final String releaseDate;
  final String externalUri;
  final int totalTracks;
  final AlbumType albumType;
  final String? recordLabel;
  final List<String>? genres;

  Album({
    required this.id,
    required this.name,
    required this.artists,
    this.images = const [],
    required this.releaseDate,
    required this.externalUri,
    required this.totalTracks,
    required this.albumType,
    this.recordLabel,
    this.genres,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "artists": artists.map((a) => a.toJson()).toList(),
      "images": images.map((i) => i.toJson()).toList(),
      "releaseDate": releaseDate,
      "externalUri": externalUri,
      "totalTracks": totalTracks,
      "albumType": albumType.name,
      "recordLabel": recordLabel,
      "genres": genres,
    };
  }

  // fromJson
  factory Album.fromJson(Map<String, dynamic> json) {
    if (json["id"] is! String) {
      throw Exception("Invalid Album: id missing");
    }

    return Album(
      id: json["id"],
      name: json["name"] ?? "",
      artists: (json["artists"] as List? ?? [])
          .map((a) => Artist.fromJson(a))
          .toList(),
      images: (json["images"] as List? ?? [])
          .map((i) => Image.fromJson(i))
          .toList(),
      releaseDate: json["releaseDate"] ?? "",
      externalUri: json["externalUri"] ?? "",
      totalTracks: json["totalTracks"] ?? 0,
      albumType: AlbumType.values.firstWhere(
        (e) => e.name == json["albumType"],
        orElse: () => AlbumType.album,
      ),
      recordLabel: json["recordLabel"],
      genres: (json["genres"] as List?)?.cast<String>(),
    );
  }
}
