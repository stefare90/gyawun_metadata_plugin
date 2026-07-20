import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/track.dart';
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

  static Artist buildArtist(Map mbData, Map? wikidataData) {
    final String aId = mbData['id'] as String;
    final String aName = mbData['name'] as String;

    final List<Image> images = [];

    if (wikidataData != null) {
      final claims = wikidataData['claims'];
      if (claims != null) {
        final p18 = claims['P18'];
        if (p18 != null && (p18 as List).isNotEmpty) {
          final Map firstClaim = p18[0] as Map;
          final Map? mainsnak = firstClaim['mainsnak'] as Map?;
          final Map? datavalue = mainsnak?['datavalue'] as Map?;
          final String? imageName = datavalue?['value'] as String?;
          if (imageName != null && imageName.isNotEmpty) {
            final String encodedName = Uri.encodeComponent(imageName);
            images.add(
              Image(
                url:
                    "https://commons.wikimedia.org/wiki/Special:FilePath/$encodedName?width=56",
                width: 56,
                height: 56,
              ),
            );
            images.add(
              Image(
                url:
                    "https://commons.wikimedia.org/wiki/Special:FilePath/$encodedName?width=250",
                width: 250,
                height: 250,
              ),
            );
            images.add(
              Image(
                url:
                    "https://commons.wikimedia.org/wiki/Special:FilePath/$encodedName?width=500",
                width: 500,
                height: 500,
              ),
            );
            images.add(
              Image(
                url:
                    "https://commons.wikimedia.org/wiki/Special:FilePath/$encodedName?width=1000",
                width: 1000,
                height: 1000,
              ),
            );
          }
        }
      }
    }

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
      path: "release",
      query: {
        'artist': id,
        'type': 'album',
        'status': 'official',
        'limit': '100',
        'offset': offset.toString(),
        'inc': 'artist-credits+release-groups',
        'fmt': 'json',
      },
    );
    if (data == null) {
      return PaginatedResult<Album>(
        items: [],
        total: 0,
        offset: offset,
        limit: limit,
      );
    }
    final rawReleases = data['releases'];
    final List<Album> uniqueAlbums = [];
    final List<String> seenGroups = [];
    for (final rObj in rawReleases) {
      final Map r = rObj as Map;
      final Map? group = r['release-group'] as Map?;
      if (group != null) {
        final String groupId = group['id'] as String;
        bool alreadySeen = false;
        for (final seenId in seenGroups) {
          if (seenId == groupId) {
            alreadySeen = true;
          }
        }
        if (!alreadySeen) {
          seenGroups.add(groupId);
          uniqueAlbums.add(MusicbrainzAlbum.buildAlbum(r));
        }
      }
    }
    final List<Album> paged = [];
    var totalUnique = uniqueAlbums.length;
    int end = offset + limit;
    if (end > totalUnique) {
      end = totalUnique;
    }
    for (var i = offset; i < end; i++) {
      paged.add(uniqueAlbums[i]);
    }
    final int total = (data['release-count'] as int?) ?? totalUnique;
    return PaginatedResult<Album>(
      items: paged,
      total: total,
      offset: offset,
      limit: limit,
    );
  }

  @override
  Future<Artist> getArtist(String id) async {
    final Map mbData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "artist/$id",
      query: {'inc': 'url-rels+release-groups+genres', 'fmt': 'json'},
    );
    String? wikidataId;
    final List? relations = mbData['relations'] as List?;
    if (relations != null) {
      for (final rObj in relations) {
        final Map rel = rObj as Map;
        final String? relType = rel['type'] as String?;
        if (relType == 'wikidata') {
          final Map? urlObj = rel['url'] as Map?;
          if (urlObj != null) {
            final String? uri = urlObj['resource'] as String?;
            if (uri != null) {
              final List<String> segments = uri.split('/');
              if (segments.isNotEmpty) {
                wikidataId = segments.last;
              }
            }
          }
        }
      }
    }
    Map? wikidataData;
    if (wikidataId != null) {
      wikidataData = await _host.fetchApi(
        baseUrl: "https://www.wikidata.org",
        path: "/w/api.php",
        query: {
          'action': 'wbgetclaims',
          'property': 'P18',
          'entity': wikidataId,
          'format': 'json',
        },
      );
    }
    return buildArtist(mbData, wikidataData);
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
      final votesA = ratingA != null
          ? (ratingA['votes-count'] as num? ?? 0)
          : 0.0;
      final votesB = ratingB != null
          ? (ratingB['votes-count'] as num? ?? 0)
          : 0.0;
      final valA = ratingA != null ? (ratingA['value'] as num? ?? 0.0) : 0.0;
      final valB = ratingB != null ? (ratingB['value'] as num? ?? 0.0) : 0.0;
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
