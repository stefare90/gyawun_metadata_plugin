abstract class IUser {
  Future<Map<String, dynamic>> me() {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> savedTracks({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> savedAlbums({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> savedArtists({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> savedPlaylists({
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }
}
