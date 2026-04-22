import 'package:gyawun_metadata_plugin/segments/auth.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iuser.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzUser extends IUser {
  final MusicbrainzAuth _auth;
  final String albumPlaylistName = "__GYAWUN_ALBUMS__";
  final String artistPlaylistName = "__GYAWUN_ARTISTS__";
  final String _lbUrl;
  final String _mbUriBase;
  final HostTools _host;
  String userId = "";

  MusicbrainzUser(this._auth, this._lbUrl, this._mbUriBase, this._host);

  @override
  Future<Map<String, dynamic>> me() async {
    if (userId == "") {
      final data = await _host.fetchApi(
        baseUrl: _lbUrl,
        path: "validate-token",
        headers: {'Authorization': 'Token ${_auth.token}'},
      );
      return {'user_id': data['user_name']};
    }
    return {'user_id': null};
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

  Future<void> saveAlbum({required String id}) async {
    throw UnimplementedError();
  }
}
