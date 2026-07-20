import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/itrack.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzTrack extends ITrack {
  final HostTools _host;
  final MusicbrainzUser user;

  MusicbrainzTrack(this._host, this.user);

  static Track buildTrack(Map recording) {
    final String id = recording['id'] as String;
    final String name = recording['title'] as String;
    final int durationMs = (recording['length'] as int?) ?? 0;

    final List<Artist> artists = [];
    final credits = recording['artist-credit'];
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
    Album album = Album(
      id: '',
      name: '',
      artists: artists,
      images: [],
      releaseDate: '',
      externalUri: '',
      totalTracks: 0,
      albumType: AlbumType.album,
    );
    final releases = recording['releases'];

    if (releases != null && releases.isNotEmpty) {
      final Map firstRelease = releases[0] as Map;
      album = MusicbrainzAlbum.buildAlbum(firstRelease);
    }
    return Track(
      id: id,
      name: name,
      durationMs: durationMs,
      externalUri: "${MusicbrainzPlugin.mbUriBase}recording/$id",
      album: album,
      artists: artists,
    );
  }

  @override
  Future<Track> getTrack(String id) async {
    final Map data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "recording/$id",
      query: {
        'fmt': 'json',
        'inc': 'artist-credits+releases+release-groups+isrcs',
      },
    );
    return buildTrack(data);
  }

  @override
  Future<void> save(List<String> ids) async {
    for (final id in ids) {
      await user.saveTrack(id: id);
    }
  }

  @override
  Future<void> unsave(List<String> ids) async {
    for (final id in ids) {
      await user.unsaveTrack(id: id);
    }
  }

  @override
  Future<List<Track>> radio(String id) async {
    final Map data = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.mbUrl,
      path: "recording/$id",
      query: {'fmt': 'json', 'inc': 'artist-credits+tags'},
    );

    final List<String> artistIds = [];
    final credits = data['artist-credit'];
    if (credits != null) {
      for (final cObj in credits) {
        final Map credit = cObj as Map;
        final Map? artist = credit['artist'] as Map?;
        if (artist != null) {
          artistIds.add(artist['id'] as String);
        }
      }
    }

    final List<String> tags = [];
    final tagsRaw = data['tags'];
    if (tagsRaw != null) {
      for (final tObj in tagsRaw) {
        final Map tag = tObj as Map;
        final String? tagName = tag['name'] as String?;
        if (tagName != null) {
          tags.add(tagName);
        }
      }
    }

    final List<String> artistQueries = [];
    for (var i = 0; i < artistIds.length; i++) {
      artistQueries.add("artist:(${artistIds[i]})");
    }
    String query = artistQueries.join(" ");

    if (tags.isNotEmpty) {
      final String tagsQuery = tags.join(",");
      query += " tag:($tagsQuery):2:easy";
    }

    final Map lbRadioData = await _host.fetchApi(
      baseUrl: MusicbrainzPlugin.lbUrl,
      path: "explore/lb-radio",
      query: {'prompt': query, 'mode': 'easy'},
    );

    final List<String> recordingMbids = [];
    final Map? payload = lbRadioData['payload'] as Map?;
    final Map? jspf = payload?['jspf'] as Map?;
    final Map? playlist = jspf?['playlist'] as Map?;

    final tracks = playlist?['track'];

    if (tracks != null) {
      for (final tObj in tracks) {
        final Map track = tObj as Map;

        final identifiers = track['identifier'];
        if (identifiers != null && identifiers.isNotEmpty) {
          final String identifier = identifiers[0] as String;
          final List<String> segments = identifier.split('/');
          if (segments.isNotEmpty) {
            recordingMbids.add("rid:${segments.last}");
          }
        }
      }
    }

    final List<Track> resultTracks = [];
    if (recordingMbids.isNotEmpty) {
      final String queryStr = recordingMbids.join(" OR ");
      final Map mbRecordingsData = await _host.fetchApi(
        baseUrl: MusicbrainzPlugin.mbUrl,
        path: "recording",
        query: {
          'fmt': 'json',
          'query': queryStr,
          'inc': 'artist-credits+releases+release-groups+isrcs',
        },
      );

      final recordings = mbRecordingsData['recordings'];
      if (recordings != null) {
        for (final rObj in recordings) {
          final Map recording = rObj as Map;
          resultTracks.add(buildTrack(recording));
        }
      }
    }

    return resultTracks;
  }
}
