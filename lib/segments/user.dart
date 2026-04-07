import 'package:gyawun_metadata_sdk/metadata/interfaces/iuser.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzUser extends IUser {
  @override
  Future<Map<String, dynamic>> me() {
    // TODO: implement me
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Album>> savedAlbums({int offset = 0, int limit = 20}) {
    // TODO: implement savedAlbums
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Artist>> savedArtists({
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement savedArtists
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Playlist>> savedPlaylists({
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement savedPlaylists
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Track>> savedTracks({int offset = 0, int limit = 20}) {
    // TODO: implement savedTracks
    throw UnimplementedError();
  }
}
