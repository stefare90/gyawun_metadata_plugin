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
          externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
        ),
      );
    }
    return Album(
      id: releaseData['id'] as String,
      name: releaseData['title'] as String,
      artists: artists,
      images: images,
      releaseDate: releaseData['date'] ?? '',
      externalUri:
          "${MusicbrainzPlugin.mbUriBase}release/${releaseData['id'] as String}",
      totalTracks: 0,
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
      query: {'inc': 'artist-credits', 'fmt': 'json'},
    );
    final coverData = await _host.fetchApi(
      baseUrl: "https://coverartarchive.org/",
      path: "release/$id",
    );
    return _buildAlbum(releaseData, coverData);
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
