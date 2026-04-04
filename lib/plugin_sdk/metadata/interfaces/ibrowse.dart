import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IBrowse {
  Future<PaginatedResult<Section>> sections({int offset = 0, int limit = 20}) {
    throw Exception('Method not implemented.');
  }

  Future<PaginatedResult<dynamic>> sectionItems(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    throw Exception('Method not implemented.');
  }
}
