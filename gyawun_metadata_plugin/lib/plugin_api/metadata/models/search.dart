import 'package:gyawun_metadata_plugin/plugin_api/metadata/models.dart';

class SearchResponse {
  final List<Album> albums;
  final List<Artist> artists;
  final List<Playlist> playlists;
  final List<Track> tracks;

  SearchResponse({
    required this.albums,
    required this.artists,
    required this.playlists,
    required this.tracks,
  });

  // 🔹 toJson
  Map<String, dynamic> toJson() {
    return {
      "albums": albums.map((a) => a.toJson()).toList(),
      "artists": artists.map((a) => a.toJson()).toList(),
      "playlists": playlists.map((p) => p.toJson()).toList(),
      "tracks": tracks.map((t) => t.toJson()).toList(),
    };
  }

  // 🔹 fromJson
  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      albums: (json["albums"] as List? ?? [])
          .map((a) => Album.fromJson(a))
          .toList(),
      artists: (json["artists"] as List? ?? [])
          .map((a) => Artist.fromJson(a))
          .toList(),
      playlists: (json["playlists"] as List? ?? [])
          .map((p) => Playlist.fromJson(p))
          .toList(),
      tracks: (json["tracks"] as List? ?? [])
          .map((t) => Track.fromJson(t))
          .toList(),
    );
  }
}
