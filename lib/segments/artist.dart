import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iartist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/image.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzArtist extends IArtist {
  final playlistName = "__GYAWUN_ARTISTS__";
  final HostTools _host;
  final MusicbrainzUser user;
  final int labsDays = 7500;
  final int labsSession = 300;
  final int labsContribution = 5;
  final int labsThreshold = 10;
  final int labsLimit = 100;
  final bool labsFilter = true;
  final int labsSkip = 30;

  MusicbrainzArtist(this._host, this.user);

  PaginatedResult<Album> _buildPaginatedAlbums(
    Map data,
    int offset,
    int limit,
  ) {
    final List<Album> items = [];
    final List? groups = data['release-groups'] as List?;
    if (groups != null) {
      for (final gObj in groups) {
        final Map g = gObj as Map;
        items.add(
          Album(
            id: g['id'] as String,
            name: g['title'] as String,
            artists: [],
            images: [],
            releaseDate: g['first-release-date'] ?? '',
            externalUri:
                "${MusicbrainzPlugin.mbUriBase}release-group/${g['id'] as String}",
            totalTracks: 0,
            albumType: AlbumType.album,
          ),
        );
      }
    }
    final int total = (data['release-group-count'] as int?) ?? items.length;
    return PaginatedResult<Album>(
      items: items,
      total: total,
      offset: offset,
      limit: limit,
    );
  }

  Artist _buildArtist(Map mbData, Map? deezerData) {
    final String aId = mbData['id'] as String;
    final String aName = mbData['name'] as String;

    final List<Image> images = [];

    if (deezerData != null) {
      final List<String> keys = [
        'picture_small',
        'picture_medium',
        'picture_big',
        'picture_xl',
      ];
      for (var i = 0; i < keys.length; i++) {
        final String key = keys[i];
        final String? url = deezerData[key] as String?;
        if (url != null && url.isNotEmpty) {
          int? size;
          final List<String> segments = url.split('/');
          if (segments.isNotEmpty) {
            final String lastSegment = segments.last;
            final List<String> dashParts = lastSegment.split('-');
            if (dashParts.isNotEmpty) {
              final String sizePart = dashParts[0];
              final List<String> xParts = sizePart.split('x');
              if (xParts.isNotEmpty) {
                size = int.tryParse(xParts[0]);
              }
            }
          }
          images.add(Image(url: url, width: size, height: size));
        }
      }
    }

    final List<String> genres = [];
    final List? genresRaw = mbData['genres'] as List?;
    if (genresRaw != null) {
      for (final gObj in genresRaw) {
        final Map g = gObj as Map;
        final String? genreName = g['name'] as String?;
        if (genreName != null && genreName.isNotEmpty) {
          genres.add(genreName);
        }
      }
    }

    return Artist(
      id: aId,
      name: aName,
      externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
      images: images,
      genres: genres.isNotEmpty ? genres : null,
      followers: null,
    );
  }

  PaginatedResult<Track> _buildTopTracks(List rawList, int offset, int limit) {
    final List<Track> items = [];

    for (final rObj in rawList) {
      final Map r = rObj as Map;
      final String? mbid = r['recording_mbid'] as String?;
      final String? name = r['recording_name'] as String?;

      if (mbid != null && name != null) {
        final List<Artist> artists = [];
        final String? artistName = r['artist_name'] as String?;
        final List? artistMbids = r['artist_mbids'] as List?;

        if (artistMbids != null &&
            artistMbids.isNotEmpty &&
            artistName != null) {
          final List mbidList = artistMbids as List;
          final String firstMbid = mbidList[0] as String;
          artists.add(
            Artist(
              id: firstMbid,
              name: artistName,
              externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$firstMbid",
            ),
          );
        }

        final String? releaseMbid = r['release_mbid'] as String?;
        final String? releaseName = r['release_name'] as String?;

        if (releaseMbid != null && releaseName != null) {
          final album = Album(
            id: releaseMbid,
            name: releaseName,
            artists: artists,
            images: [],
            releaseDate: '',
            externalUri: "${MusicbrainzPlugin.mbUriBase}release/$releaseMbid",
            totalTracks: 0,
            albumType: AlbumType.album,
          );

          items.add(
            Track(
              id: mbid,
              name: name,
              durationMs: 0,
              externalUri: "${MusicbrainzPlugin.mbUriBase}recording/$mbid",
              album: album,
              artists: artists,
            ),
          );
        }
      }
    }

    final List<Track> paged = [];
    int end = offset + limit;
    if (end > items.length) {
      end = items.length;
    }
    for (int j = offset; j < end; j++) {
      paged.add(items[j]);
    }

    return PaginatedResult<Track>(
      items: paged,
      total: items.length,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PaginatedResult<Album>> albums(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release-group",
      query: {
        'artist': id,
        'type': 'album',
        'limit': limit.toString(),
        'offset': offset.toString(),
        'fmt': 'json',
      },
    );
    return _buildPaginatedAlbums(data, offset, limit);
  }

  @override
  Future<Artist> getArtist(String id) async {
    final Map mbData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "artist/$id",
      query: {'inc': 'url-rels+release-groups+genres', 'fmt': 'json'},
    );
    String? deezerId;
    final List? relations = mbData['relations'] as List?;
    if (relations != null) {
      for (final rObj in relations) {
        final Map rel = rObj as Map;
        final Map? urlObj = rel['url'] as Map?;
        if (urlObj != null) {
          final String? uri = urlObj['resource'] as String?;
          if (uri != null && uri.contains('deezer.com/')) {
            final List<String> segments = uri.split('/');
            for (var i = 0; i < segments.length; i++) {
              if (segments[i] == 'artist' && (i + 1) < segments.length) {
                deezerId = segments[i + 1];
              }
            }
          }
        }
      }
    }
    Map? deezerData;
    if (deezerId != null) {
      deezerData = await _host.fetchApi(
        baseUrl: "https://api.deezer.com",
        path: "/artist/$deezerId",
      );
    }

    return _buildArtist(mbData, deezerData);
  }

  @override
  Future<PaginatedResult<Artist>> related(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final String filterStr = labsFilter ? "True" : "False";
    final String algorithm =
        "session_based_days_${labsDays}_session_${labsSession}_contribution_${labsContribution}_threshold_${labsThreshold}_limit_${labsLimit}_filter_${filterStr}_skip_$labsSkip";
    final rawSimilar = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbLabsUrl,
      path: "/similar-artists/json",
      query: {'artist_mbids': id, 'algorithm': algorithm},
    );

    final List<Artist> items = [];
    int length = rawSimilar.length;
    final end = (offset + limit) > length ? length : (offset + limit);

    for (int i = offset; i < end; i++) {
      final Map s = rawSimilar[i] as Map;
      final String? mbid = s['artist_mbid'] as String?;
      if (mbid != null) {
        final Artist fullArtist = await getArtist(mbid);
        items.add(fullArtist);
      }
    }

    return PaginatedResult<Artist>(
      items: items,
      total: length,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<void> save(List<String> ids) async {
    for (final id in ids) {
      user.saveArtist(id: id);
    }
  }

  @override
  Future<void> unsave(List<String> ids) async {
    for (final id in ids) {
      user.unsaveArtist(id: id);
    }
  }

  @override
  Future<PaginatedResult<Track>> topTracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final dynamic data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "popularity/top-recordings-for-artist/$id",
    );

    return _buildTopTracks(data as List, offset, limit);
  }
}
