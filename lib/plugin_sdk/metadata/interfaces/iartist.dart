import '../models.dart';

import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IArtist {
  IArtist();
  Future<Artist> getArtist(String id) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Track>> topTracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Album>> albums(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Artist>> related(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<void> save(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<void> unsave(List<String> ids) {
    throw Exception('Method not implemented.');
  }
}
