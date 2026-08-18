import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/ialbum.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/image.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzAlbum extends IAlbum {
  final playlistName = "__GYAWUN_ALBUMS__";
  final HostTools _host;
  final MusicbrainzUser user;

  MusicbrainzAlbum(this._host, this.user);

  static Album buildAlbum(Map releaseData) {
    final List<Image> images = [];
    final coverArt = releaseData['cover-art-archive'];
    if (coverArt != null) {
      final bool? hasFront = coverArt['front'] as bool?;
      if (hasFront == true) {
        final String releaseId = releaseData['id'] as String;
        images.add(
          Image(
            url: "https://coverartarchive.org/release/$releaseId/front-250.jpg",
            width: 250,
            height: 250,
          ),
        );
        images.add(
          Image(
            url: "https://coverartarchive.org/release/$releaseId/front-500.jpg",
            width: 500,
            height: 500,
          ),
        );
      }
    }
    final List<Artist> artists = [];
    final credits = releaseData['artist-credit'];
    if (credits != null) {
      for (final cObj in credits) {
        final Map c = cObj as Map;
        final Map a = c['artist'] as Map;
        final String aId = a['id'] as String;
        artists.add(
          Artist(
            id: aId,
            name: a['name'] as String,
            externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
          ),
        );
      }
    }
    int trackCount = 0;
    final mediaList = releaseData['media'];
    if (mediaList != null) {
      for (final mObj in mediaList) {
        final Map m = mObj as Map;
        final int? mCount = m['track-count'] as int?;
        if (mCount != null) {
          trackCount += mCount;
        }
      }
    }

    String finalId = releaseData['id'] as String;
    AlbumType albumType = AlbumType.album;
    final rg = releaseData['release-group'];
    if (rg != null && rg is Map) {
      if (rg['id'] != null) {
        finalId = "rg:${rg['id']}";
      }
      final rawPrimaryType = rg['primary-type'];
      final String primaryType = rawPrimaryType != null
          ? rawPrimaryType.toString().toLowerCase()
          : '';
      if (primaryType == 'single') {
        albumType = AlbumType.single;
      } else if (primaryType == 'compilation') {
        albumType = AlbumType.compilation;
      }
    }

    return Album(
      id: finalId,
      name: releaseData['title'] as String,
      artists: artists,
      images: images,
      releaseDate: releaseData['date'] ?? '',
      externalUri:
          "${MusicbrainzPlugin.mbUriBase}release/${releaseData['id'] as String}",
      totalTracks: trackCount,
      albumType: albumType,
    );
  }

  static Album buildAlbumFromReleaseGroup(Map groupData) {
    final String gId = groupData['id'] as String;
    final String title = groupData['title'] as String;

    final rawDate = groupData['first-release-date'];
    final String releaseDate = rawDate != null ? rawDate.toString() : '';

    final List<Artist> artists = [];
    final credits = groupData['artist-credit'];
    if (credits != null && credits is List) {
      for (final cObj in credits) {
        if (cObj != null && cObj is Map) {
          final Map c = cObj;
          final Map? a = c['artist'] as Map?;
          if (a != null) {
            final String aId = a['id'] as String;
            artists.add(
              Artist(
                id: aId,
                name: a['name'] as String,
                externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
              ),
            );
          }
        }
      }
    }

    final rawPrimaryType = groupData['primary-type'];
    final String primaryType = rawPrimaryType != null
        ? rawPrimaryType.toString().toLowerCase()
        : '';

    var albumType = AlbumType.album;
    if (primaryType == 'single') {
      albumType = AlbumType.single;
    } else if (primaryType == 'compilation') {
      albumType = AlbumType.compilation;
    }

    final List<Image> images = [
      Image(
        url: "https://coverartarchive.org/release-group/$gId/front-250.jpg",
        width: 250,
        height: 250,
      ),
      Image(
        url: "https://coverartarchive.org/release-group/$gId/front-500.jpg",
        width: 500,
        height: 500,
      ),
      Image(
        url: "https://coverartarchive.org/release-group/$gId/front-1200.jpg",
        width: 1200,
        height: 1200,
      ),
    ];

    return Album(
      id: "rg:$gId",
      name: title,
      artists: artists,
      images: images,
      releaseDate: releaseDate,
      externalUri: "${MusicbrainzPlugin.mbUriBase}release-group/$gId",
      totalTracks: 0,
      albumType: albumType,
    );
  }

  PaginatedResult<Track> _buildTracks(
    Map tracksData,
    Album album,
    int offset,
    int limit,
  ) {
    final List<Track> tracks = [];
    for (final tObj in tracksData['recordings']) {
      final List<Artist> artists = [];
      final List credits = tObj['artist-credit'] as List;
      for (final cObj in credits) {
        final Map c = cObj as Map;
        final Map a = c['artist'] as Map;
        final String aId = a['id'] as String;
        artists.add(
          Artist(
            id: aId,
            name: a['name'] as String,
            externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
          ),
        );
      }
      final Map t = tObj as Map;
      tracks.add(
        Track(
          id: t['id'] as String,
          name: t['title'] as String,
          durationMs: t['length'] ?? 0,
          externalUri: "${MusicbrainzPlugin.mbUriBase}recording/${t['id']}",
          album: album,
          artists: artists,
        ),
      );
    }
    final int totalRecordings =
        (tracksData['recording-count'] as int?) ?? tracks.length;
    return PaginatedResult<Track>(
      items: tracks,
      total: totalRecordings,
      offset: offset,
      limit: limit,
    );
  }

  Future<String> _resolveReleaseId(String id) async {
    if (id.startsWith('rg:')) {
      final rgId = id.substring(3);
      final data = await _host.fetchApi(
        baseUrl: MusicbrainzPlugin.mbUrl,
        path: "release",
        query: {'release-group': rgId, 'limit': '1', 'fmt': 'json'},
      );
      final releases = data['releases'] as List?;
      if (releases != null && releases.isNotEmpty) {
        return releases.first['id'] as String;
      }
      throw Exception("No releases found for release group $rgId");
    }
    return id;
  }

  Future<String> _ensureReleaseGroupId(String id) async {
    if (id.startsWith('rg:')) return id.substring(3);

    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release/$id",
      query: {'inc': 'release-groups', 'fmt': 'json'},
    );
    final rg = data['release-group'];
    if (rg != null && rg is Map && rg['id'] != null) {
      return rg['id'] as String;
    }
    throw Exception("No release group found for release $id");
  }

  @override
  Future<Album> getAlbum(String id) async {
    final releaseId = await _resolveReleaseId(id);
    final releaseData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release/$releaseId",
      headers: {},
      query: {'inc': 'artist-credits+recordings+release-groups', 'fmt': 'json'},
    );
    return buildAlbum(releaseData);
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final releaseId = await _resolveReleaseId(id);
    final releaseData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release/$releaseId",
      headers: {},
      query: {'inc': 'artist-credits+recordings+release-groups', 'fmt': 'json'},
    );
    final album = buildAlbum(releaseData);
    final tracksData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "recording",
      query: {
        'release': releaseId,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'inc': 'artist-credits',
        'fmt': 'json',
      },
    );
    return _buildTracks(tracksData, album, offset, limit);
  }

  @override
  Future<void> save(List<String> ids) async {
    for (String id in ids) {
      final rgId = await _ensureReleaseGroupId(id);
      await user.saveAlbum(id: rgId);
    }
  }

  @override
  Future<void> unsave(List<String> ids) async {
    for (String id in ids) {
      final rgId = await _ensureReleaseGroupId(id);
      await user.unsaveAlbum(id: rgId);
    }
  }
}
