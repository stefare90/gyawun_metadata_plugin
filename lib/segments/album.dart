import 'dart:convert';

import 'package:gyawun_metadata_plugin/plugin_sdk/metadata_plugin_sdk.dart';

class MusicbrainzAlbum implements IAlbum {
  final String mbUrl;

  MusicbrainzAlbum(this.mbUrl);

  Future<Map<String, dynamic>> _get(
    String baseUrl,
    String path,
    Map<String, String> query,
  ) async {
    final queryString = query.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final url = "$baseUrl$path?$queryString";

    final request = PluginRequest(
      url: url,
      method: 'GET',
      headers: {'Accept': 'application/json'},
    );

    final PluginResponse response = await MetadataHost.network.send(request);

    if (response.statusCode != 200) {
      throw Exception("Errore API: ${response.statusCode}");
    }
    return jsonDecode(response.body);
  }

  @override
  Future<Album> getAlbum(String id) async {
    final data = await _get(mbUrl, "/release-group/$id", {
      "fmt": "json",
      "inc": "artists",
    });
    return Album(
      id: data['id'],
      name: data['title'],
      artists: (data['artist-credit'] as List)
          .map(
            (a) => Artist(
              id: a['artist']['id'],
              name: a['artist']['name'],
              externalUri: "$mbUrl/artist/${a['artist']['id']}",
            ),
          )
          .toList(),
      images: [],
      releaseDate: data['first-release-date'] ?? '',
      externalUri: "$mbUrl/release-group/${data['id']}",
      totalTracks: 0,
      albumType: AlbumType.album,
    );
  }

  @override
  Future<PaginatedResult<Album>> releases({int offset = 0, int limit = 20}) {
    // TODO: implement releases
    throw UnimplementedError();
  }

  @override
  Future<void> save(List<String> ids) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement tracks
    throw UnimplementedError();
  }

  @override
  Future<void> unsave(List<String> ids) {
    // TODO: implement unsave
    throw UnimplementedError();
  }
}
