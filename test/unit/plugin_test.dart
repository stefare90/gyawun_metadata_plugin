import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:test/test.dart';

import '../_support/mock_network_service.dart';

void main() {
  group('IAlbum tests', () {
    HostEnv hostEnv = HostEnv(network: MockNetworkServiceRealCall());
    final awesome = MusicbrainzPlugin(hostEnv: hostEnv);

    setUp(() {});

    test('Test get Album', () async {
      final result = await awesome.album.getAlbum("...");
      expect(result, isA<Album>());
      expect(result.id, equals("123"));
      expect(result.name, equals("Test Album"));
    });
  });
}
