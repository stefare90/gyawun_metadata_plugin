import 'package:gyawun_metadata_plugin/src/plugin_api/metadata/models.dart';

class Track {
  final String id;
  final String name;
  final String externalUri;
  final List<Artist> artists;
  final Album album;
  final int durationMs;
  final String? path; // opzionale (per eventuale uso locale)

  Track({
    required this.id,
    required this.name,
    required this.externalUri,
    this.artists = const [],
    required this.album,
    required this.durationMs,
    this.path,
  });

  // 🔹 toJson
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "externalUri": externalUri,
      "artists": artists.map((a) => a.toJson()).toList(),
      "album": album.toJson(),
      "durationMs": durationMs,
      "path": path,
    };
  }

  // 🔹 fromJson
  factory Track.fromJson(Map<String, dynamic> json) {
    if (json["id"] is! String) {
      throw Exception("Invalid Track: id missing");
    }

    return Track(
      id: json["id"],
      name: json["name"] ?? "",
      externalUri: json["externalUri"] ?? "",
      artists: (json["artists"] as List? ?? [])
          .map((a) => Artist.fromJson(a))
          .toList(),
      album: Album.fromJson(json["album"] ?? {}),
      durationMs: json["durationMs"] ?? 0,
      path: json["path"],
    );
  }
}
