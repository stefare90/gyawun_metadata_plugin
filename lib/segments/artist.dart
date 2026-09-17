import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/track.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_plugin/segments/wikidata_images.dart';
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
  final WikidataArtistImages _images;
  final int labsDays = 7500;
  final int labsSession = 300;
  final int labsContribution = 5;
  final int labsThreshold = 10;
  final int labsLimit = 100;
  final bool labsFilter = true;
  final int labsSkip = 30;

  MusicbrainzArtist(this._host, this.user, this._images);

  static Artist buildArtist(Map mbData, List<Image> images) {
    final String aId = mbData['id'] as String;
    final String aName = mbData['name'] as String;

    final List<String> genres = [];
    final genresRaw = mbData['genres'];
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
        'inc': 'artist-credits',
        'fmt': 'json',
      },
    );

    if (data == null || data['release-groups'] == null) {
      return PaginatedResult<Album>(
        items: [],
        total: 0,
        offset: offset,
        limit: limit,
      );
    }

    final rawGroups = data['release-groups'];
    if (rawGroups is! List) {
      return PaginatedResult<Album>(
        items: [],
        total: 0,
        offset: offset,
        limit: limit,
      );
    }

    final List<Album> items = [];
    for (final gObj in rawGroups) {
      if (gObj != null && gObj is Map) {
        items.add(MusicbrainzAlbum.buildAlbumFromReleaseGroup(gObj));
      }
    }

    int totalCount = items.length;
    final rawTotal = data['release-group-count'] ?? data['count'];
    if (rawTotal != null && rawTotal is int) {
      totalCount = rawTotal;
    }

    return PaginatedResult<Album>(
      items: items,
      total: totalCount,
      offset: offset,
      limit: limit,
    );
  }

  Future<Map> _fetchArtistMbData(String id) async {
    final Map mbData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "artist/$id",
      query: {'inc': 'genres', 'fmt': 'json'},
    );
    return mbData;
  }

  @override
  Future<Artist> getArtist(String id) async {
    final Map mbData = await _fetchArtistMbData(id);
    final Map<String, List<Image>> imagesMap = await _images.resolve(<String>[
      id,
    ]);
    List<Image> images = <Image>[];
    final List<Image>? found = imagesMap[id];
    if (found != null) {
      images = found;
    }
    return buildArtist(mbData, images);
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

    int length = rawSimilar.length;
    final end = (offset + limit) > length ? length : (offset + limit);

    final List<Map> profiles = <Map>[];
    final List<String> mbids = <String>[];

    for (int i = offset; i < end; i++) {
      final Map s = rawSimilar[i] as Map;
      final String? mbid = s['artist_mbid'] as String?;
      if (mbid != null) {
        final Map mbData = await _fetchArtistMbData(mbid);
        profiles.add(mbData);
        mbids.add(mbid);
      }
    }

    final Map<String, List<Image>> imagesMap = await _images.resolve(mbids);

    final List<Artist> items = [];
    for (final Map mbData in profiles) {
      final String id = mbData['id'] as String;
      List<Image> images = <Image>[];
      final List<Image>? found = imagesMap[id];
      if (found != null) {
        images = found;
      }
      items.add(buildArtist(mbData, images));
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
      await user.saveArtist(id: id);
    }
  }

  @override
  Future<void> unsave(List<String> ids) async {
    for (final id in ids) {
      await user.unsaveArtist(id: id);
    }
  }

  @override
  Future<PaginatedResult<Track>> topTracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) async {
    final dynamic data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "release",
      query: {
        'fmt': 'json',
        'artist': id,
        'limit': '5',
        'offset': '0',
        'inc': 'artist-credits+recordings+ratings+isrcs+release-groups',
      },
    );

    if (data == null || data['releases'] == null) {
      return PaginatedResult<Track>(
        items: [],
        total: 0,
        offset: offset,
        limit: limit,
      );
    }
    final rawReleases = data['releases'];
    final List<Map> tracksRaw = [];

    for (final rObj in rawReleases) {
      final Map release = rObj as Map;
      final mediaList = release['media'];

      if (mediaList != null) {
        final List mediaBackup = List.from(mediaList);
        release['media'] = null;

        for (final mObj in mediaBackup) {
          final Map media = mObj as Map;
          final tracksList = media['tracks'];

          if (tracksList != null) {
            for (final tObj in tracksList) {
              final Map track = tObj as Map;
              final Map? recording = track['recording'] as Map?;
              if (recording != null) {
                recording['releases'] = [release];
                tracksRaw.add(recording);
              }
            }
          }
        }
      }
    }

    final List<Map> uniqueTracksRaw = [];
    final List<String> seenTitles = [];

    for (final recording in tracksRaw) {
      final String? title = recording['title'] as String?;
      if (title != null) {
        if (!seenTitles.contains(title)) {
          seenTitles.add(title);
          uniqueTracksRaw.add(recording);
        }
      }
    }

    uniqueTracksRaw.sort((a, b) {
      final ratingA = a['rating'];
      final ratingB = b['rating'];
      final votesA = ratingA != null ? (ratingA['votes-count'] ?? 0) : 0.0;
      final votesB = ratingB != null ? (ratingB['votes-count'] ?? 0) : 0.0;
      final valA = ratingA != null ? (ratingA['value'] ?? 0.0) : 0.0;
      final valB = ratingB != null ? (ratingB['value'] ?? 0.0) : 0.0;
      final aAvg = votesA > 0.0 ? valA / votesA : 0.0;
      final bAvg = votesB > 0.0 ? valB / votesB : 0.0;
      return bAvg.compareTo(aAvg);
    });

    final List<Track> items = [];
    for (final recording in uniqueTracksRaw) {
      items.add(MusicbrainzTrack.buildTrack(recording));
    }

    final int localOffset = offset.toInt();
    final int localLimit = limit.toInt();

    int end = localOffset + localLimit;
    if (end > items.length) {
      end = items.length;
    }

    final List<Track> paged = [];
    for (int i = localOffset; i < end; i++) {
      paged.add(items[i]);
    }

    return PaginatedResult<Track>(
      items: paged,
      total: items.length,
      offset: localOffset,
      limit: localLimit,
    );
  }
}
