import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class ITrack {
  Future<Track> getTrack(String id) {
    throw Exception('Method not implemented.');
  }

  Future<void> save(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<void> unsave(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<List<Track>> radio(String id) {
    throw Exception('Method not implemented.');
  }
}
