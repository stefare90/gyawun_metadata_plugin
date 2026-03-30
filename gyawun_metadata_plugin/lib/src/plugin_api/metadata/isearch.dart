abstract class ISearch {
  List<String> chips() {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> all(String query) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> tracks(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> albums(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> artists(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> playlists(
    String query, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }
}
