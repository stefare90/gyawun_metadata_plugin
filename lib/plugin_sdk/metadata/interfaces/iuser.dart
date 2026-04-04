import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IUser {
  Future<Map<String, dynamic>> me() {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Track>> savedTracks({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Album>> savedAlbums({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Artist>> savedArtists({
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Playlist>> savedPlaylists({
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }
}
