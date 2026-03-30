abstract class IAlbum {
  IAlbum();

  Future<Map<String, dynamic>> getAlbum(String id) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> tracks(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> releases({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<void> save(List<String> ids) {
    throw Exception('Method not implemented.');
  }

  Future<void> unsave(List<String> ids) {
    throw Exception('Method not implemented.');
  }
}
