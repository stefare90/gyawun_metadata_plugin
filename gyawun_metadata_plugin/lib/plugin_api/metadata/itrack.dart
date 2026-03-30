abstract class ITrack {
  Future<Map<String, dynamic>> getTrack(String id) {
    throw Exception('Method not implemented.');
  }

  Future<void> save(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<void> unsave(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<List<Map<String, dynamic>>> radio(String id) {
    throw Exception('Method not implemented.');
  }
}
