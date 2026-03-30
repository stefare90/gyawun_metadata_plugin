abstract class IArtist {
  IArtist();
  Future<Map<String, dynamic>> getArtist(String id) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> topTracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> albums(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> related(
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
