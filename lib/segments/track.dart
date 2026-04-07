import 'package:gyawun_metadata_sdk/metadata/interfaces/itrack.dart';
import 'package:gyawun_metadata_sdk/metadata/models/track.dart';

class MusicbrainzTrack extends ITrack {
  @override
  Future<Track> getTrack(String id) {
    // TODO: implement getTrack
    throw UnimplementedError();
  }

  @override
  Future<List<Track>> radio(String id) {
    // TODO: implement radio
    throw UnimplementedError();
  }

  @override
  Future<void> save(List<String> ids) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> unsave(List<String> ids) {
    // TODO: implement unsave
    throw UnimplementedError();
  }
}
