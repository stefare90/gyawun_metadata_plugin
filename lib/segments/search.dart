import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/track.dart';
import 'package:gyawun_metadata_plugin/segments/wikidata_images.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/isearch.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/search.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzSearch extends ISearch {
  final HostTools _host;
  final WikidataArtistImages _images;

  MusicbrainzSearch(this._host, this._images);

  @override
  List<String> chips() {
    return ['Tracks', 'Albums', 'Artists'];
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: 'recording',
      query: {
        'query': query,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'fmt': 'json',
      },
    );

    final List<Track> items = [];
    int total = 0;

    if (data != null && data is Map) {
      final Map map = data;
      final rawCount = map['count'];
      if (rawCount != null && rawCount is int) {
        total = rawCount;
      }
      final rawRecordings = map['recordings'];
      if (rawRecordings != null && rawRecordings is List) {
        for (final rObj in rawRecordings) {
          if (rObj != null && rObj is Map) {
            final Map r = rObj;
            items.add(MusicbrainzTrack.buildTrack(r));
          }
        }
      }
    }

    return PaginatedResult<Track>(
      items: items,
      total: total,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PaginatedResult<Album>> albums(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: 'release-group',
      query: {
        'query': query,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'fmt': 'json',
      },
    );

    final List<Album> items = [];
    int total = 0;

    if (data != null && data is Map) {
      final Map map = data;
      final rawCount = map['count'];
      if (rawCount != null && rawCount is int) {
        total = rawCount;
      }
      final rawGroups = map['release-groups'];
      if (rawGroups != null && rawGroups is List) {
        for (final gObj in rawGroups) {
          if (gObj != null && gObj is Map) {
            final Map g = gObj;
            items.add(MusicbrainzAlbum.buildAlbumFromReleaseGroup(g));
          }
        }
      }
    }

    return PaginatedResult<Album>(
      items: items,
      total: total,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PaginatedResult<Artist>> artists(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    final data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: 'artist',
      query: {
        'query': query,
        'limit': limit.toString(),
        'offset': offset.toString(),
        'fmt': 'json',
      },
    );

    final List<Artist> items = [];
    int total = 0;

    if (data != null && data is Map) {
      final Map map = data;
      final rawCount = map['count'];
      if (rawCount != null && rawCount is int) {
        total = rawCount;
      }
      final rawArtists = map['artists'];
      if (rawArtists != null && rawArtists is List) {
        for (final aObj in rawArtists) {
          if (aObj != null && aObj is Map) {
            final Map a = aObj;
            final String aId = a['id'] as String;
            final String aName = a['name'] as String;

            final List<String> genres = [];
            final tagsRaw = a['tags'];
            if (tagsRaw != null && tagsRaw is List) {
              for (final tObj in tagsRaw) {
                if (tObj != null && tObj is Map) {
                  final Map t = tObj;
                  final String? tagName = t['name'] as String?;
                  if (tagName != null && tagName.isNotEmpty) {
                    genres.add(tagName);
                  }
                }
              }
            }

            items.add(
              Artist(
                id: aId,
                name: aName,
                externalUri: "${MusicbrainzPlugin.mbUriBase}artist/$aId",
                genres: genres.isNotEmpty ? genres : null,
              ),
            );
          }
        }
      }
    }

    final List<Artist> enriched = await _images.enrich(items);

    return PaginatedResult<Artist>(
      items: enriched,
      total: total,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<PaginatedResult<Playlist>> playlists(
    String query, {
    int offset = 0,
    int limit = 20,
  }) async {
    return PaginatedResult<Playlist>(
      items: [],
      total: 0,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<SearchResponse> all(String query) async {
    final tracksResult = await tracks(query, limit: 5);
    final albumsResult = await albums(query, limit: 5);
    final artistsResult = await artists(query, limit: 5);

    return SearchResponse(
      albums: albumsResult.items,
      artists: artistsResult.items,
      playlists: [],
      tracks: tracksResult.items,
    );
  }
}
