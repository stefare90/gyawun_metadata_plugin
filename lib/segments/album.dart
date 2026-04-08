import 'dart:convert';

import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/ialbum.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/image.dart';
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
    String url = "$baseUrl$path";
    if (queryString.isNotEmpty) {
      url += "?$queryString";
    }
    final request = PluginRequest(
      url: url,
      method: 'GET',
      headers: {'Accept': 'application/json'},
    );
    print("Sending API request to $url with headers: ${request.headers}");
    final PluginResponse response = await hostEnv.network.send(request);
    print("API Response for $url: ${response.statusCode} ${response.body}");
    if (response.statusCode != 200) {
      throw Exception("Errore API: ${response.statusCode}");
    }
    return jsonDecode(response.body);
  }

  @override
  Future<Album> getAlbum(String id) async {
    final releaseData = await _get(mbUrl, "release/$id", {
      'inc': 'artist-credits',
      'fmt': 'json',
    });
    final coverData = await _get(
      "https://coverartarchive.org/",
      "release/$id",
      {},
    );
    final List imagesList = coverData['images'] ?? [];
    late List<Image> images = imagesList
        .map((img) => Image(url: img['image'] as String))
        .toList();
    return Album(
      id: releaseData['id'],
      name: releaseData['title'],
      artists: (releaseData['artist-credit'] as List)
          .map(
            (a) => Artist(
              id: a['artist']['id'],
              name: a['artist']['name'],
              externalUri: "${mbUrl}artist/${a['artist']['id']}",
            ),
          )
          .toList(),
      images: images,
      releaseDate: releaseData['first-release-date'] ?? '',
      externalUri: "${mbUrl}release-group/${releaseData['id']}",
      totalTracks: 0,
      albumType: AlbumType.album,
    );
  }

  @override
  Future<PaginatedResult<Album>> releases({
    int offset = 0,
    int limit = 20,
  }) async {
    await Future.delayed(Duration.zero);
    return PaginatedResult<Album>(
      items: [
        Album(
          id: "123",
          name: "Test Album",
          artists: [],
          releaseDate: "",
          externalUri: "$mbUrl/release-group/123",
          totalTracks: 0,
          albumType: AlbumType.album,
        ),
      ],
      total: 1,
      offset: offset,
      limit: limit,
    );
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
