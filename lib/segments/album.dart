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
    return Album(
      id: releaseData['id'] as String,
      name: releaseData['title'] as String,
      artists: artists,
      images: images,
      releaseDate: releaseData['date'] ?? '',
      externalUri:
          "${MusicbrainzPlugin.mbUriBase}release/${releaseData['id'] as String}",
      totalTracks: trackCount,
      albumType: AlbumType.album,
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
          durationMs: (t['length'] as int?) ?? 0,
          externalUri: "${MusicbrainzPlugin.mbUriBase}recording/${t['id']}",
          album: album,
          artists: artists,
        ),
      );
    }
    return PaginatedResult<Track>(
      items: tracks,
      total: tracks.length,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<Album> getAlbum(String id) async {
    final releaseData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release/$id",
      headers: {},
      query: {'inc': 'artist-credits+recordings', 'fmt': 'json'},
    );
    return buildAlbum(releaseData);
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final album = await getAlbum(id);
    final tracksData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "recording",
      query: {
        'release': id,
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
      user.saveAlbum(id: id);
    }
  }

  @override
  Future<void> unsave(List<String> ids) async {
    for (String id in ids) {
      user.unsaveAlbum(id: id);
    }
  }
}
