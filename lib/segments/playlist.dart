import 'package:gyawun_metadata_sdk/metadata/interfaces/iplaylist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzPlaylist extends IPlaylist {
  @override
  Future<void> addTracks(
    String playlistId,
    List<String> trackIds, {
    int? position,
  }) {
    // TODO: implement addTracks
    throw UnimplementedError();
  }

  @override
  Future<Playlist?> createPlaylist(
    String userId,
    String name, {
    String? description,
    bool? public_,
    bool? collaborative,
  }) {
    // TODO: implement createPlaylist
    throw UnimplementedError();
  }

  @override
  Future<void> deletePlaylist(String playlistId) {
    // TODO: implement deletePlaylist
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getPlaylist(String id) {
    // TODO: implement getPlaylist
    throw UnimplementedError();
  }

  @override
  Future<void> removeTracks(String playlistId, List<String> trackIds) {
    // TODO: implement removeTracks
    throw UnimplementedError();
  }

  @override
  Future<void> save(String playlistId) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement tracks
    throw UnimplementedError();
  }

  @override
  Future<void> unsave(String playlistId) {
    // TODO: implement unsave
    throw UnimplementedError();
  }

  @override
  Future<void> updatePlaylist(
    String playlistId, {
    String? name,
    String? description,
    bool? public_,
    bool? collaborative,
  }) {
    // TODO: implement updatePlaylist
    throw UnimplementedError();
  }
}
