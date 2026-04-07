import 'package:gyawun_metadata_sdk/metadata/interfaces/icore.dart';

class MusicbrainzCore extends ICore {
  @override
  Future<Map<String, dynamic>?> checkUpdate(Map<String, dynamic> pluginConfig) {
    // TODO: implement checkUpdate
    throw UnimplementedError();
  }

  @override
  Future<void> scrobble(Map<String, dynamic> details) {
    // TODO: implement scrobble
    throw UnimplementedError();
  }

  @override
  String support() {
    // TODO: implement support
    throw UnimplementedError();
  }
}
