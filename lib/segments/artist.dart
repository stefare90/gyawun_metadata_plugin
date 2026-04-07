import 'package:gyawun_metadata_sdk/metadata/interfaces/iartist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzArtist extends IArtist {
  @override
  Future<PaginatedResult<Album>> albums(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement albums
    throw UnimplementedError();
  }

  @override
  Future<Artist> getArtist(String id) {
    // TODO: implement getArtist
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Artist>> related(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement related
    throw UnimplementedError();
  }

  @override
  Future<void> save(List<String> ids) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Track>> topTracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement topTracks
    throw UnimplementedError();
  }

  @override
  Future<void> unsave(List<String> ids) {
    // TODO: implement unsave
    throw UnimplementedError();
  }
}
