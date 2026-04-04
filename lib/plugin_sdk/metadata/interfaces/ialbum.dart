import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IAlbum {
  IAlbum();

  Future<Album> getAlbum(String id) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Album>> releases({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<void> save(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<void> unsave(List<String> ids) {
    throw Exception('Method not implemented.');
  }
}
