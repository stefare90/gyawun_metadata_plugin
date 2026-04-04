import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IPlaylist {
  Future<Map<String, dynamic>> getPlaylist(String id) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<Track>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Playlist?> createPlaylist(
    String userId,
    String name, {
    String? description,
    bool? public_,
    bool? collaborative,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<void> updatePlaylist(
    String playlistId, {
    String? name,
    String? description,
    bool? public_,
    bool? collaborative,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<void> deletePlaylist(String playlistId) {
    throw Exception('Method not implemented.');
  }

  Future<void> addTracks(
    String playlistId,
    List<String> trackIds, {
    int? position,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<void> removeTracks(String playlistId, List<String> trackIds) {
    throw Exception('Method not implemented.');
  }

  Future<void> save(String playlistId) {
    throw Exception('Method not implemented.');
  }

  Future<void> unsave(String playlistId) {
    throw Exception('Method not implemented.');
  }
}
