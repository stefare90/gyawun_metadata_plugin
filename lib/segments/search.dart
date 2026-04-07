import 'package:gyawun_metadata_sdk/metadata/interfaces/isearch.dart';
import 'package:gyawun_metadata_sdk/metadata/models/album.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/playlist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/search.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzSearch extends ISearch {
  @override
  Future<PaginatedResult<Album>> albums(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement albums
    throw UnimplementedError();
  }

  @override
  Future<SearchResponse> all(String query) {
    // TODO: implement all
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Artist>> artists(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement artists
    throw UnimplementedError();
  }

  @override
  List<String> chips() {
    // TODO: implement chips
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Playlist>> playlists(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement playlists
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Track>> tracks(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement tracks
    throw UnimplementedError();
  }
}
