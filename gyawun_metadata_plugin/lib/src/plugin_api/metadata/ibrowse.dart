abstract class IBrowse {
  Future<Map<String, dynamic>> sections({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<Map<String, dynamic>> sectionItems(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }
}
