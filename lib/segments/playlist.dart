import 'dart:convert';

import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iplaylist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';
import 'package:gyawun_metadata_sdk/metadata/models/user.dart';

class MusicbrainzPlaylist extends IPlaylist {
  final HostTools _host;
  final MusicbrainzUser _user;

  MusicbrainzPlaylist(this._host, this._user);

  @override
  Future<Map<String, dynamic>> getPlaylist(String id) async {
    final headers = <String, String>{};
    if (_user.token != "") {
      headers['Authorization'] = 'Token ${_user.token}';
    }

    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "playlist/$id",
      headers: headers,
    );

    final Map rawMap = data as Map;
    final Map<String, dynamic> resultMap = {};
    for (final key in rawMap.keys) {
      resultMap[key as String] = rawMap[key];
    }

    return resultMap;
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final playlistData = await getPlaylist(id);
    final playlist = playlistData['playlist'];
    final tracks = playlist?['track'];

    final List<Track> items = [];
    var totalCount = 0;

    if (tracks != null) {
      final tracksList = List.from(tracks);
      totalCount = tracksList.length;

      var index = 0;
      for (final trackObj in tracksList) {
        if (index >= offset && index < offset + limit) {
          final track = trackObj;
          final identifiers = track['identifier'];

          if (identifiers != null) {
            final String identifier = identifiers[0] as String;
            final List parts = identifier.split('/');
            final String trackId = parts[parts.length - 1] as String;

            final titleVal = track['title'];
            final String title = titleVal != null
                ? titleVal.toString()
                : "Unknown Track";

            final creatorVal = track['creator'];
            final String creator = creatorVal != null
                ? creatorVal.toString()
                : "Unknown Artist";

            final albumVal = track['album'];
            final String albumName = albumVal != null
                ? albumVal.toString()
                : "";

            final List<Artist> artists = [
              Artist(id: '', name: creator, externalUri: '', images: []),
            ];

            final Album album = Album(
              id: '',
              name: albumName,
              artists: artists,
              images: [],
              releaseDate: '',
              externalUri: '',
              totalTracks: 0,
              albumType: AlbumType.album,
            );

            items.add(
              Track(
                id: trackId,
                name: title,
                durationMs: 0,
                externalUri: "https://musicbrainz.org/recording/$trackId",
                album: album,
                artists: artists,
              ),
            );
          }
        }
        index++;
      }
    }

    return PaginatedResult<Track>(
      items: items,
      total: totalCount,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<void> addTracks(
    String playlistId,
    List<String> trackIds, {
    int? position,
  }) async {
    final List<Map> jspfTracks = [];

    for (final idObj in trackIds) {
      final id = idObj.toString();

      final trackData = await _host.fetchApi(
        baseUrl: MusicbrainzPlugin.mbUrl,
        path: "recording/$id",
        query: {'fmt': 'json', 'inc': 'artist-credits'},
      );

      final titleVal = trackData['title'];
      final String title = titleVal != null
          ? titleVal.toString()
          : "Unknown Track";

      var artistName = "Unknown Artist";
      final credits = trackData['artist-credit'];

      if (credits != null) {
        final creditsList = List.from(credits);
        if (creditsList.isNotEmpty) {
          final firstCredit = creditsList[0] as Map;
          final artist = firstCredit['artist'];
          if (artist != null) {
            final artistMap = artist as Map;
            artistName = artistMap['name'] as String;
          }
        }
      }

      final Map<String, dynamic> trackItem = {};
      trackItem['identifier'] = "https://musicbrainz.org/recording/$id";
      trackItem['title'] = title;
      trackItem['creator'] = artistName;

      jspfTracks.add(trackItem);
    }

    final Map<String, dynamic> body = {
      'playlist': {'track': jspfTracks},
    };

    if (position != null) {
      body['index'] = position;
    }

    final addRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/$playlistId/item/add",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_user.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final response = await _host.env.network.send(addRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to add tracks: ${response.body}");
    }
  }

  @override
  Future<void> removeTracks(String playlistId, List<String> trackIds) async {
    final playlistData = await getPlaylist(playlistId);
    final playlist = playlistData['playlist'];
    final tracks = playlist?['track'];
    if (playlist == null || tracks == null) return;

    final tracksList = List.from(tracks);
    final List<int> reversedIndices = [];

    var index = 0;
    for (final trackObj in tracksList) {
      final track = trackObj;
      final identifiers = track['identifier'];
      if (identifiers != null) {
        final String identifier = identifiers[0] as String;
        final List parts = identifier.split('/');
        final String mbid = parts[parts.length - 1] as String;

        if (trackIds.contains(mbid)) {
          reversedIndices.insert(0, index);
        }
      }
      index++;
    }

    for (final indexToDelete in reversedIndices) {
      final deleteRequest = PluginRequest(
        url: "${MusicbrainzPlugin.lbUrl}playlist/$playlistId/item/delete",
        method: 'POST',
        headers: {
          'Authorization': 'Token ${_user.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'index': indexToDelete, 'count': 1}),
      );

      final response = await _host.env.network.send(deleteRequest);
      if (response.statusCode != 200) {
        throw Exception(
          "Failed to delete item from playlist: ${response.body}",
        );
      }
    }
  }

  @override
  Future<Playlist?> createPlaylist(
    String userId,
    String name, {
    String? description,
    bool? public_,
    bool? collaborative,
  }) async {
    final createRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/create",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_user.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'playlist': {
          'title': name,
          'annotation': description ?? 'Created by Gyawun Plugin',
          'extension': {
            'https://musicbrainz.org/doc/jspf#playlist': {
              'public': public_ ?? false,
            },
          },
        },
      }),
    );

    final response = await _host.env.network.send(createRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to create playlist: ${response.body}");
    }

    final Map responseData = jsonDecode(response.body);
    final String playlistMbid = responseData['playlist_mbid'] as String;

    return Playlist(
      id: playlistMbid,
      name: name,
      description: description ?? "",
      externalUri: "https://listenbrainz.org/playlist/$playlistMbid",
      owner: User(
        id: userId,
        name: userId,
        externalUri: "https://listenbrainz.org/user/$userId",
        images: [],
      ),
      images: [],
      collaborative: collaborative ?? false,
      isPublic: public_ ?? false,
    );
  }

  @override
  Future<void> save(String playlistId) async {
    await _user.savePlaylist(id: playlistId);
  }

  @override
  Future<void> unsave(String playlistId) async {
    await _user.unsavePlaylist(id: playlistId);
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    await _user.unsavePlaylist(id: playlistId);
  }

  @override
  Future<void> updatePlaylist(
    String playlistId, {
    String? name,
    String? description,
    bool? public_,
    bool? collaborative,
  }) async {
    final playlistData = await getPlaylist(playlistId);
    final playlist = playlistData['playlist'];
    if (playlist == null) return;

    final titleVal = playlist['title'];
    final String finalName =
        name ?? (titleVal != null ? titleVal.toString() : "Untitled Playlist");

    final descVal = playlist['annotation'];
    final String finalDesc =
        description ?? (descVal != null ? descVal.toString() : "");

    var isPublicVal = public_ ?? false;
    if (public_ == null) {
      final ext = playlist['extension'];
      if (ext != null) {
        final extMap = ext as Map;
        final mbExt = extMap['https://musicbrainz.org/doc/jspf#playlist'];
        if (mbExt != null) {
          final mbExtMap = mbExt as Map;
          final publicVal = mbExtMap['public'];
          isPublicVal = publicVal is bool ? publicVal : false;
        }
      }
    }

    final editRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/edit/$playlistId",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_user.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'playlist': {
          'title': finalName,
          'annotation': finalDesc,
          'extension': {
            'https://musicbrainz.org/doc/jspf#playlist': {
              'public': isPublicVal,
            },
          },
        },
      }),
    );

    final response = await _host.env.network.send(editRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to edit playlist: ${response.body}");
    }
  }
}
