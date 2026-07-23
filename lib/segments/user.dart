import 'dart:convert';
import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/auth.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/track.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iuser.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/image.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';
import 'package:gyawun_metadata_sdk/metadata/models/user.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';

class MusicbrainzUser extends IUser {
  final MusicbrainzAuth _auth;
  final String albumPlaylistName = "__GYAWUN_ALBUMS__";
  final String artistPlaylistName = "__GYAWUN_ARTISTS__";
  final HostTools _host;
  String userId = "";

  MusicbrainzUser(this._auth, this._host);

  String get token => _auth.token;

  Future<String> _getOrCreatePlaylist(String title) async {
    String username = "listenbrainz";
    final Map userData = await me();
    if (userData['user_id'] != null) {
      username = userData['user_id'] as String;
    }

    final Map data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "user/$username/playlists",
      headers: _auth.token != ""
          ? {'Authorization': 'Token ${_auth.token}'}
          : {},
    );

    final rawPlaylists = data['playlists'];
    if (rawPlaylists != null) {
      for (final itemObj in rawPlaylists) {
        final Map item = itemObj as Map;
        final Map? playlist = item['playlist'] as Map?;
        if (playlist != null) {
          final String playlistTitle = playlist['title'] as String;
          if (playlistTitle == title) {
            final String playlistUri = playlist['identifier'] as String;
            return playlistUri.split('/').last;
          }
        }
      }
    }

    final createRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/create",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_auth.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'playlist': {
          'title': title,
          'annotation': 'Private metadata playlist created by Spotube',
          'extension': {
            'https://musicbrainz.org/doc/jspf#playlist': {'public': false},
          },
        },
      }),
    );

    final response = await _host.env.network.send(createRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to create playlist: ${response.body}");
    }

    final Map responseData = jsonDecode(response.body);
    return responseData['playlist_mbid'] as String;
  }

  @override
  Future<Map<String, dynamic>> me() async {
    if (userId == "") {
      if (_auth.token == "") {
        return {'user_id': null};
      }
      final data = await _host.fetchApi(
        baseUrl: MusicbrainzPlugin.lbUrl,
        path: "validate-token",
        headers: {'Authorization': 'Token ${_auth.token}'},
      );
      userId = data['user_name'] as String;
    }
    return {'user_id': userId};
  }

  @override
  Future<PaginatedResult<Track>> savedTracks({
    int offset = 0,
    int limit = 20,
  }) async {
    var username = "listenbrainz";

    final userData = await me();
    if (userData['user_id'] != null) {
      username = userData['user_id'] as String;
    }

    final Map<String, String> headers = _auth.token != ""
        ? {'Authorization': 'Token ${_auth.token}'}
        : {};

    final feedbackData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "feedback/user/$username/get-feedback",
      headers: headers,
      query: {
        'score': '1',
        'count': (offset + limit).toString(),
        'offset': '0',
      },
    );

    final List<Track> items = [];
    var totalCount = 0;

    if (feedbackData['feedback'] != null) {
      final rawFeedback = List.from(feedbackData['feedback']);
      totalCount = rawFeedback.length;

      final List<String> recordingMbids = [];

      var index = 0;
      for (final feedbackObj in rawFeedback) {
        if (index >= offset && index < offset + limit) {
          final feedback = feedbackObj;
          final mbid = feedback['recording_mbid'];
          if (mbid != null) {
            recordingMbids.add("rid:$mbid");
          }
        }
        index++;
      }

      if (recordingMbids.isNotEmpty) {
        final queryStr = recordingMbids.join(" OR ");
        final mbData = await _host.fetchApi(
          baseUrl: MusicbrainzPlugin.mbUrl,
          path: "recording",
          query: {
            'fmt': 'json',
            'query': queryStr,
            'inc': 'artist-credits+releases+release-groups+isrcs',
          },
        );

        final recordings = mbData['recordings'];
        if (recordings != null) {
          final recordingsList = List.from(recordings);
          for (final recordingObj in recordingsList) {
            items.add(MusicbrainzTrack.buildTrack(recordingObj));
          }
        }
      }
    }
    return PaginatedResult<Track>(
      items: items,
      total: totalCount,
      offset: offset,
      limit: limit,
    );
  }

  Future<void> saveTrack({required String id}) async {
    final request = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}feedback/recording-feedback",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_auth.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'recording_mbid': id, 'score': 1}),
    );
    final response = await _host.env.network.send(request);
    if (response.statusCode != 200) {
      throw Exception("Failed to save track: ${response.body}");
    }
  }

  Future<void> unsaveTrack({required String id}) async {
    final request = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}feedback/recording-feedback",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_auth.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'recording_mbid': id, 'score': 0}),
    );
    final response = await _host.env.network.send(request);
    if (response.statusCode != 200) {
      throw Exception("Failed to unsave track: ${response.body}");
    }
  }

  @override
  Future<PaginatedResult<Playlist>> savedPlaylists({
    int offset = 0,
    int limit = 20,
  }) async {
    final userData = await me();
    var username = "listenbrainz";
    if (userData['user_id'] != null) {
      username = userData['user_id'] as String;
    }

    final headers = <String, String>{};
    if (_auth.token != "") {
      headers['Authorization'] = 'Token ${_auth.token}';
    }

    final playlistsData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "user/$username/playlists",
      headers: headers,
    );

    final List<Playlist> items = [];
    final rawPlaylists = playlistsData['playlists'];
    if (rawPlaylists != null) {
      for (final itemObj in rawPlaylists) {
        final Map item = itemObj as Map;
        final Map? playlist = item['playlist'] as Map?;
        if (playlist != null) {
          final String playlistUri = playlist['identifier'] as String;

          final parts = playlistUri.split('/');
          final playlistId = parts[parts.length - 1];
          final String title = playlist['title'] as String;

          if (title != albumPlaylistName && title != artistPlaylistName) {
            final descVal = playlist['annotation'];
            final String desc = descVal != null ? descVal.toString() : "";

            final creatorVal = playlist['creator'];
            final String creator = creatorVal != null
                ? creatorVal.toString()
                : username;

            items.add(
              Playlist(
                id: playlistId,
                name: title,
                description: desc,
                externalUri: playlistUri,
                owner: User(
                  id: creator,
                  name: creator,
                  externalUri: "https://listenbrainz.org/user/$creator",
                ),
                images: [],
              ),
            );
          }
        }
      }
    }

    final List<Playlist> paged = [];
    int index = 0;
    for (final item in items) {
      if (index >= offset && index < offset + limit) {
        paged.add(item);
      }
      index++;
    }

    return PaginatedResult<Playlist>(
      items: paged,
      total: items.length,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PaginatedResult<Artist>> savedArtists({
    int offset = 0,
    int limit = 20,
  }) async {
    final List<Artist> items = [];
    var totalCount = 0;

    final playlistMbid = await _getOrCreatePlaylist(artistPlaylistName);

    final headers = <String, String>{};
    if (_auth.token != "") {
      headers['Authorization'] = 'Token ${_auth.token}';
    }

    final playlistData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "playlist/$playlistMbid",
      headers: headers,
    );

    final playlist = playlistData['playlist'];
    final tracks = playlist?['track'];

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
            final String artistMbid = parts[parts.length - 1] as String;

            final artistData = await _host.fetchApi(
              baseUrl: MusicbrainzPlugin.mbUrl,
              path: "artist/$artistMbid",
              query: {'fmt': 'json'},
            );
            items.add(
              Artist(
                id: artistMbid,
                name: artistData['name'] as String,
                externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$artistMbid",
                images: [],
              ),
            );
          }
        }
        index++;
      }
    }

    if (items.isEmpty && offset == 0) {
      var username = "listenbrainz";
      final userData = await me();
      if (userData['user_id'] != null) {
        username = userData['user_id'] as String;
      }

      final statsHeaders = <String, String>{};
      if (_auth.token != "") {
        statsHeaders['Authorization'] = 'Token ${_auth.token}';
      }

      final statsData = await _host.fetchApi(
        baseUrl: MusicbrainzPlugin.lbUrl,
        path: "stats/user/$username/artists",
        headers: statsHeaders,
        query: {'range': 'all_time', 'count': (offset + limit).toString()},
      );

      final payload = statsData['payload'];
      final rawArtists = payload != null ? payload['artists'] : null;

      if (rawArtists != null) {
        final artistsList = List.from(rawArtists);
        totalCount = artistsList.length;

        var statsIndex = 0;
        for (final artistObj in artistsList) {
          if (statsIndex >= offset && statsIndex < offset + limit) {
            final artist = artistObj;
            final artistName =
                artist['artist_name'] ?? artist['artist_credit_name'];
            final mbid = artist['artist_mbid'];

            items.add(
              Artist(
                id: mbid as String,
                name: artistName as String,
                externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$mbid",
                images: [],
              ),
            );
          }
          statsIndex++;
        }
      }
    }

    return PaginatedResult<Artist>(
      items: items,
      total: totalCount,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PaginatedResult<Album>> savedAlbums({
    int offset = 0,
    int limit = 20,
  }) async {
    final playlistMbid = await _getOrCreatePlaylist(albumPlaylistName);

    final headers = <String, String>{};
    if (_auth.token != "") {
      headers['Authorization'] = 'Token ${_auth.token}';
    }

    final playlistData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "playlist/$playlistMbid",
      headers: headers,
    );

    final playlist = playlistData['playlist'];
    final tracks = playlist?['track'];
    final List<Album> items = [];

    if (tracks != null) {
      final tracksList = List.from(tracks);

      int index = 0;
      for (final track in tracksList) {
        if (index >= offset && index < offset + limit) {
          final identifiers = track['identifier'];

          if (identifiers != null) {
            final String identifier = identifiers[0] as String;
            final List parts = identifier.split('/');
            final String albumId = parts[parts.length - 1] as String;

            final albumData = await _host.fetchApi(
              baseUrl: MusicbrainzPlugin.mbUrl,
              path: "release-group/$albumId",
              query: {'fmt': 'json', 'inc': 'artist-credits'},
            );

            final List<Artist> artists = [];
            final credits = albumData['artist-credit'];
            if (credits != null) {
              for (final cObj in credits) {
                final c = cObj;
                final a = c['artist'];
                final aId = a['id'];
                artists.add(
                  Artist(
                    id: aId,
                    name: a['name'] as String,
                    externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
                  ),
                );
              }
            }

            final primaryType = albumData['primary-type'];
            final type = primaryType != null
                ? primaryType.toString().toLowerCase()
                : "album";

            var albumType = AlbumType.album;
            if (type == "single") {
              albumType = AlbumType.single;
            } else if (type == "compilation") {
              albumType = AlbumType.compilation;
            }

            final firstReleaseDate = albumData['first-release-date'] ?? "";

            items.add(
              Album(
                id: albumId,
                name: albumData['title'] as String,
                artists: artists,
                images: [
                  Image(
                    url:
                        "https://coverartarchive.org/release-group/$albumId/front-250.jpg",
                    width: 250,
                    height: 250,
                  ),
                  Image(
                    url:
                        "https://coverartarchive.org/release-group/$albumId/front-500.jpg",
                    width: 500,
                    height: 500,
                  ),
                ],
                releaseDate: firstReleaseDate as String,
                externalUri:
                    "${MusicbrainzPlugin.mbUriBase}release-group/$albumId",
                totalTracks: 0,
                albumType: albumType,
              ),
            );
          }
        }
        index++;
      }
    }

    final totalCount = tracks != null ? tracks.length : 0;

    return PaginatedResult<Album>(
      items: items,
      total: totalCount,
      offset: offset,
      limit: limit,
    );
  }

  Future<void> saveAlbum({required String id}) async {
    final String playlistMbid = await _getOrCreatePlaylist(albumPlaylistName);

    final Map albumData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release-group/$id",
      query: {'fmt': 'json', 'inc': 'artist-credits'},
    );

    final title = albumData['title'];
    String artistName = "Unknown Artist";
    final credits = albumData['artist-credit'];

    if (credits != null) {
      final firstCredit = credits[0];
      final artist = firstCredit['artist'];
      if (artist != null) {
        artistName = artist['name'] as String;
      }
    }

    final addRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/$playlistMbid/item/add",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_auth.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'playlist': {
          'track': [
            {
              'identifier': "https://musicbrainz.org/recording/$id",
              'title': title,
              'creator': artistName,
            },
          ],
        },
      }),
    );

    final response = await _host.env.network.send(addRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to save album: ${response.body}");
    }
  }

  Future<void> unsaveAlbum({required String id}) async {
    final String playlistMbid = await _getOrCreatePlaylist(albumPlaylistName);
    final Map<String, String> headers = {};
    if (_auth.token != "") {
      headers['Authorization'] = 'Token ${_auth.token}';
    }
    final Map playlistData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "playlist/$playlistMbid",
      headers: headers,
    );
    final playlist = playlistData['playlist'];
    final tracks = playlist?['track'];
    if (playlist == null || tracks == null) return;
    final tracksList = List.from(tracks);

    final List<int> reversedIndices = [];
    var index = 0;
    for (final trackObj in tracksList) {
      final track = trackObj as Map;
      final identifiers = track['identifier'];
      if (identifiers != null) {
        final String identifier = identifiers[0] as String;
        if (identifier.contains(id)) {
          reversedIndices.insert(0, index);
        }
      }
      index++;
    }

    for (final indexToDelete in reversedIndices) {
      final deleteRequest = PluginRequest(
        url: "${MusicbrainzPlugin.lbUrl}playlist/$playlistMbid/item/delete",
        method: 'POST',
        headers: {
          'Authorization': 'Token ${_auth.token}',
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

  Future<void> saveArtist({required String id}) async {
    final playlistMbid = await _getOrCreatePlaylist(artistPlaylistName);

    final Map artistData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "artist/$id",
      query: {'fmt': 'json'},
    );

    final title = artistData['name'] as String;

    final addRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/$playlistMbid/item/add",
      method: 'POST',
      headers: {
        'Authorization': 'Token ${_auth.token}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'playlist': {
          'track': [
            {
              'identifier': "https://musicbrainz.org/recording/$id",
              'title': title,
              'creator': title,
            },
          ],
        },
      }),
    );

    final response = await _host.env.network.send(addRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to save artist: ${response.body}");
    }
  }

  Future<void> unsaveArtist({required String id}) async {
    final playlistMbid = await _getOrCreatePlaylist(artistPlaylistName);

    final Map playlistData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "playlist/$playlistMbid",
      headers: _auth.token != ""
          ? {'Authorization': 'Token ${_auth.token}'}
          : {},
    );

    final playlist = playlistData['playlist'];
    final tracks = playlist?['track'];
    if (playlist == null || tracks == null) return;

    final tracksList = List.from(tracks);
    final List<int> reversedIndices = [];

    var index = 0;
    for (final trackObj in tracksList) {
      final track = trackObj as Map;
      final identifiers = track['identifier'];
      if (identifiers != null) {
        final String identifier = identifiers[0] as String;
        if (identifier.contains(id)) {
          reversedIndices.insert(0, index);
        }
      }
      index++;
    }

    for (final indexToDelete in reversedIndices) {
      final deleteRequest = PluginRequest(
        url: "${MusicbrainzPlugin.lbUrl}playlist/$playlistMbid/item/delete",
        method: 'POST',
        headers: {
          'Authorization': 'Token ${_auth.token}',
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

  Future<void> savePlaylist({required String id}) async {
    final saveRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/$id/copy",
      method: 'POST',
      headers: {'Authorization': 'Token ${_auth.token}'},
    );
    final response = await _host.env.network.send(saveRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to save playlist: ${response.body}");
    }
  }

  Future<void> unsavePlaylist({required String id}) async {
    final deleteRequest = PluginRequest(
      url: "${MusicbrainzPlugin.lbUrl}playlist/$id/delete",
      method: 'POST',
      headers: {'Authorization': 'Token ${_auth.token}'},
    );
    final response = await _host.env.network.send(deleteRequest);
    if (response.statusCode != 200) {
      throw Exception("Failed to delete playlist: ${response.body}");
    }
  }
}
