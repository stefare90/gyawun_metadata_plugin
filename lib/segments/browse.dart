import 'package:gyawun_metadata_sdk/metadata/interfaces/ibrowse.dart';
import 'package:gyawun_metadata_sdk/metadata/models/pagination.dart';
import 'package:gyawun_metadata_sdk/metadata/models/section.dart';

class MusicbrainzBrowse extends IBrowse {
  @override
  Future<PaginatedResult<dynamic>> sectionItems(
    String id, {
    int offset = 0,
    int limit = 20,
  }) {
    // TODO: implement sectionItems
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<Section>> sections({int offset = 0, int limit = 20}) {
    // TODO: implement sections
    throw UnimplementedError();
  }
}
