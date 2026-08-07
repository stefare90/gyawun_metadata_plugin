import 'dart:convert';

import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iplaylist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/image.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';
import 'package:gyawun_metadata_sdk/metadata/models/user.dart';

class MusicbrainzPlaylist extends IPlaylist {
  final HostTools _host;
  final MusicbrainzUser _user;

  MusicbrainzPlaylist(this._host, this._user);

  List<Artist> _extractTrackArtists(dynamic trackObj) {
    final List<Artist> artists = [];
    final creatorVal = trackObj['creator'];
    final fallbackCreator = creatorVal != null
        ? creatorVal.toString()
        : "Unknown Artist";
    final ext = trackObj['extension'];
    if (ext != null) {
      final mbExt = ext['https://musicbrainz.org/doc/jspf#track'];
      if (mbExt != null) {
        final identifiers = mbExt['artist_identifiers'];
        if (identifiers != null) {
          for (final item in identifiers) {
            if (item != null) {
              final uri = item as String;
              final parts = uri.split('/');
              if (parts.isNotEmpty) {
                final artistMbid = parts[parts.length - 1].toString();
                if (artistMbid != "null" && artistMbid != "") {
                  artists.add(
                    Artist(
                      id: artistMbid,
                      name: fallbackCreator,
                      externalUri:
                          "${MusicbrainzPlugin.mbUriBase}artist/$artistMbid",
                    ),
                  );
                }
              }
            }
          }
        }
      }
    }
    if (artists.isEmpty) {
      artists.add(Artist(id: '', name: fallbackCreator, externalUri: ''));
    }
    return artists;
  }

  String _extractAlbumMbid(dynamic trackObj) {
    final ext = trackObj['extension'];
    if (ext != null) {
      final mbExt = ext['https://musicbrainz.org/doc/jspf#track'];
      if (mbExt != null) {
        final addMeta = mbExt['additional_metadata'];
        if (addMeta != null) {
          final caaMbid = addMeta['caa_release_mbid'];
          if (caaMbid != null) {
            final s = caaMbid.toString();
            if (s != "null" && s != "") return s;
          }
        }
        final directMbid = mbExt['release_mbid'];
        if (directMbid != null) {
          final s = directMbid.toString();
          if (s != "null" && s != "") return s;
        }
        final directGroupMbid = mbExt['release_group_mbid'];
        if (directGroupMbid != null) {
          final s = directGroupMbid.toString();
          if (s != "null" && s != "") return s;
        }
      }
    }
    return '';
  }

  List<Image> _extractTrackImages(dynamic trackObj, String releaseMbid) {
    final List<Image> images = [];
    if (trackObj.containsKey('image') && trackObj['image'] != null) {
      final imageVal = trackObj['image'];
      final s = imageVal.toString();
      if (s != "null" && s != "") {
        images.add(Image(url: s, width: 250, height: 250));
        return images;
      }
    }
    if (releaseMbid.isNotEmpty && releaseMbid != "null") {
      images.add(
        Image(
          url: "https://coverartarchive.org/release/$releaseMbid/front-250.jpg",
          width: 250,
          height: 250,
        ),
      );
      images.add(
        Image(
          url: "https://coverartarchive.org/release/$releaseMbid/front-500.jpg",
          width: 500,
          height: 500,
        ),
      );
    }
    return images;
  }

  Future<Map> _fetchRawPlaylistData(String id) async {
    if (id.startsWith("radio:")) {
      return await _getRadioPlaylistMetadata(id);
    }
    final headers = <String, String>{};
    if (_user.token != "") {
      headers['Authorization'] = 'Token ${_user.token}';
    }
    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "playlist/$id",
      headers: headers,
    );
    return data as Map;
  }

  @override
  Future<Playlist> getPlaylist(String id) async {
    final rawData = await _fetchRawPlaylistData(id);
    final rawPlaylist = rawData['playlist'];
    if (rawPlaylist == null) {
      throw Exception("Playlist not found: $id");
    }
    final playlistMap = rawPlaylist as Map;
    final titleVal = playlistMap['title'];
    final String title = titleVal != null
        ? titleVal.toString()
        : "Untitled Playlist";
    final descVal = playlistMap['annotation'];
    final String desc = descVal != null ? descVal.toString() : "";
    final creatorVal = playlistMap['creator'];
    final String creator = creatorVal != null
        ? creatorVal.toString()
        : "Unknown";
    var isPublic = false;
    final ext = playlistMap['extension'];
    if (ext != null && ext is Map) {
      final mbExt = ext['https://musicbrainz.org/doc/jspf#playlist'];
      if (mbExt != null && mbExt is Map) {
        final publicVal = mbExt['public'];
        isPublic = publicVal is bool ? publicVal : false;
      }
    }
    final List<Image> playlistImages = [];
    final tracks = playlistMap['track'];
    if (tracks != null && tracks is List) {
      for (final trackObj in tracks) {
        if (trackObj != null) {
          final albumMbid = _extractAlbumMbid(trackObj);
          if (albumMbid.isNotEmpty) {
            playlistImages.add(
              Image(
                url:
                    "https://coverartarchive.org/release/$albumMbid/front-250.jpg",
                width: 250,
                height: 250,
              ),
            );
          }
        }
        if (playlistImages.length >= 4) break;
      }
    }
    return Playlist(
      id: id,
      name: title,
      description: desc,
      externalUri: "https://listenbrainz.org/playlist/$id",
      owner: User(
        id: creator,
        name: creator,
        externalUri: "https://listenbrainz.org/user/$creator",
        images: [],
      ),
      images: playlistImages,
      isPublic: isPublic,
    );
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    if (id.startsWith("radio:")) {
      return await _getRadioPlaylistTracks(id, offset: offset, limit: limit);
    }
    final playlistData = await _fetchRawPlaylistData(id);
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
            final title = titleVal != null
                ? titleVal.toString()
                : "Unknown Track";
            final albumVal = track['album'];
            final albumName = albumVal != null ? albumVal.toString() : "";
            final artists = _extractTrackArtists(track);
            final albumMbid = _extractAlbumMbid(track);
            final albumImages = _extractTrackImages(track, albumMbid);
            final releaseUri = (albumMbid.isNotEmpty && albumMbid != "null")
                ? "${MusicbrainzPlugin.mbUriBase}release/$albumMbid"
                : "";
            final album = Album(
              id: albumMbid,
              name: albumName,
              artists: artists,
              images: albumImages,
              releaseDate: '',
              externalUri: releaseUri,
              totalTracks: 0,
              albumType: AlbumType.album,
            );
            items.add(
              Track(
                id: trackId,
                name: title,
                durationMs: 0,
                externalUri: "${MusicbrainzPlugin.mbUriBase}recording/$trackId",
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
      final title = titleVal != null ? titleVal.toString() : "Unknown Track";
      var artistName = "Unknown Artist";
      final credits = trackData['artist-credit'];
      if (credits != null) {
        final creditsList = List.from(credits);
        if (creditsList.isNotEmpty) {
          final firstCredit = creditsList[0];
          final artist = firstCredit['artist'];
          if (artist != null) {
            artistName = artist['name'].toString();
          }
        }
      }
      final Map<String, dynamic> trackItem = {};
      trackItem['identifier'] = "${MusicbrainzPlugin.mbUriBase}recording/$id";
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
    final playlistData = await _fetchRawPlaylistData(playlistId);
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
        final identifier = identifiers[0] as String;
        final parts = identifier.split('/');
        final mbid = parts[parts.length - 1];
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
    final playlistMbid = responseData['playlist_mbid'].toString();
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
    final playlistData = await _fetchRawPlaylistData(playlistId);
    final playlist = playlistData['playlist'];
    if (playlist == null) return;
    final titleVal = playlist['title'];
    final finalName =
        name ?? (titleVal != null ? titleVal.toString() : "Untitled Playlist");
    final descVal = playlist['annotation'];
    final finalDesc =
        description ?? (descVal != null ? descVal.toString() : "");
    var isPublicVal = public_ ?? false;
    if (public_ == null) {
      final ext = playlist['extension'];
      if (ext != null) {
        final mbExt = ext['https://musicbrainz.org/doc/jspf#playlist'];
        if (mbExt != null) {
          final publicVal = mbExt['public'];
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

  Future<Map<String, dynamic>> _getRadioPlaylistMetadata(String id) async {
    var title = "Radio";
    var description = "Algorithmic recommendation radio";
    if (id.startsWith("radio:artist:")) {
      final artistName = id.substring(13);
      title = "$artistName Radio";
      description = "Algorithmic recommendation radio based on $artistName";
    } else if (id.startsWith("radio:tag:")) {
      final tag = id.substring(10);
      var moodTitle = "Mood";
      if (tag == "romantic") moodTitle = "Romantic Mood";
      if (tag == "chill") moodTitle = "Chill Mood";
      if (tag == "happy") moodTitle = "Happy Mood";
      if (tag == "sad") moodTitle = "Sad Mood";
      if (tag == "focus") moodTitle = "Focus Mood";
      title = moodTitle;
      description =
          "Algorithmic recommendations generated based on the $tag mood";
    }
    final Map<String, dynamic> mockPlaylist = {
      'playlist': {
        'title': title,
        'annotation': description,
        'creator': 'listenbrainz',
        'identifier': 'https://listenbrainz.org/playlist/$id',
        'track': [],
        'extension': {
          'https://musicbrainz.org/doc/jspf#playlist': {'public': false},
        },
      },
    };
    return mockPlaylist;
  }

  Future<PaginatedResult<Track>> _getRadioPlaylistTracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    String prompt = "";
    if (id.startsWith("radio:artist:")) {
      final artistName = id.substring(13);
      prompt = "artist:($artistName)";
    } else if (id.startsWith("radio:tag:")) {
      final tag = id.substring(10);
      prompt = "tag:($tag)";
    }
    final Map lbRadioData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "explore/lb-radio",
      query: {'prompt': prompt, 'mode': 'easy'},
    );
    final List<Track> items = [];
    var totalCount = 0;
    final payload = lbRadioData['payload'];
    final jspf = payload != null ? payload['jspf'] : null;
    final playlist = jspf != null ? jspf['playlist'] : null;
    final tracks = playlist != null ? playlist['track'] : null;
    if (tracks != null) {
      final tracksList = List.from(tracks);
      totalCount = tracksList.length;
      var index = 0;
      for (final trackObj in tracksList) {
        if (index >= offset && index < offset + limit) {
          final track = trackObj;
          final identifiers = track['identifier'];
          if (identifiers != null) {
            final identifier = identifiers[0] as String;
            final parts = identifier.split('/');
            final trackId = parts[parts.length - 1];
            final String titleVal = "${track['title']}";
            final String title = (titleVal != "null" && titleVal.isNotEmpty)
                ? titleVal
                : "Unknown Track";
            final String albumVal = "${track['album']}";
            final String albumName = (albumVal != "null" && albumVal.isNotEmpty)
                ? albumVal
                : "";
            final artists = _extractTrackArtists(track);
            final albumMbid = _extractAlbumMbid(track);
            final albumImages = _extractTrackImages(track, albumMbid);
            final String releaseUri =
                (albumMbid.isNotEmpty && albumMbid != "null")
                ? "${MusicbrainzPlugin.mbUriBase}release/$albumMbid"
                : "";
            final Album album = Album(
              id: albumMbid,
              name: albumName,
              artists: artists,
              images: albumImages,
              releaseDate: '',
              externalUri: releaseUri,
              totalTracks: 0,
              albumType: AlbumType.album,
            );
            items.add(
              Track(
                id: trackId,
                name: title,
                durationMs: 0,
                externalUri: "${MusicbrainzPlugin.mbUriBase}recording/$trackId",
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
}
