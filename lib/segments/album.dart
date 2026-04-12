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

  Album _buildAlbum(Map releaseData, Map coverData) {
    Map? cover;
    final List imgs = coverData['images'] as List;
    for (final imgObj in imgs) {
      final img = imgObj as Map;
      if (img['front'] == true && cover == null) {
        cover = img;
      }
    }
    List<Image> images = [];
    if (cover != null) {
      final Map thbMap = cover['thumbnails'] as Map;
      final List thbValues = thbMap.values.toList();
      final String imageUrl = cover['image'] as String;
      final int dotIndex = imageUrl.lastIndexOf('.');
      if (dotIndex != -1) {
        final String base = imageUrl.substring(0, dotIndex);
        final String ext = imageUrl.substring(dotIndex);
        for (final thbObj in thbValues) {
          final String thb = thbObj as String;
          String s = thb.replaceAll(base, "");
          s = s.replaceAll(ext, "");
          s = s.replaceAll("-", "");
          final int? length = int.tryParse(s);
          images.add(Image(url: thb, width: length, height: length));
        }
      }
    }
    final List<Artist> artists = [];
    final List credits = releaseData['artist-credit'] as List;
    for (final cObj in credits) {
      final Map c = cObj as Map;
      final Map a = c['artist'] as Map;
      final String aId = a['id'] as String;
      artists.add(
        Artist(
          id: aId,
          name: a['name'] as String,
          externalUri: "${mbUrl}artist/$aId",
        ),
      );
    }
    return Album(
      id: releaseData['id'] as String,
      name: releaseData['title'] as String,
      artists: artists,
      images: images,
      releaseDate: releaseData['date'] ?? '',
      externalUri: "${mbUrl}release-group/${releaseData['id'] as String}",
      totalTracks: 0,
      albumType: AlbumType.album,
    );
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
    return _buildAlbum(releaseData, coverData);
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
