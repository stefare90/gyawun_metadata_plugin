import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/itrack.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzTrack extends ITrack {
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
    if (releases != null && (releases as List).isNotEmpty) {
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
  Future<Track> getTrack(String id) {
    // TODO: implement getTrack
    throw UnimplementedError();
  }

  @override
  Future<List<Track>> radio(String id) {
    // TODO: implement radio
    throw UnimplementedError();
  }

  @override
  Future<void> save(List<String> ids) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> unsave(List<String> ids) {
    // TODO: implement unsave
    throw UnimplementedError();
  }
}
