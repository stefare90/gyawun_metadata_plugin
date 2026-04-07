import 'dart:convert';

import 'package:gyawun_metadata_plugin/main.dart';
import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/ialbum.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_response.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzAlbum extends IAlbum {
  final String mbUrl;
  final HostEnv hostEnv;

  MusicbrainzAlbum(this.mbUrl, this.hostEnv);

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

    final PluginResponse responset = await hostEnv.network.send(request);

    final PluginResponse response = PluginResponse(
      statusCode: 200,
      body: jsonEncode({
        "id": "123",
        "title": "Test Album",
        "artist-credit": [],
      }),
    );

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
