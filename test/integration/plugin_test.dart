import 'dart:io';
import 'package:gyawun_metadata_sdk/eval/eval_plugin.dart';
import 'package:gyawun_metadata_sdk/eval/host_env.eval.dart';
import 'package:test/test.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';

import '../_support/mock_network_service.dart';

void main() async {
  group('Plugin Integration Test - Album interface test', () {
    late IMetadataPlugin plugin;

    setUpAll(() async {
      final file = File('plugin.evc');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'Bytecode file should exist at plugin.evc',
      );
      final bytes = file.readAsBytesSync();

      // 2. INITIALIZE RUNTIME
      final runtime = Runtime(bytes.buffer.asByteData());

      // 3. ADD PLUGIN TO RUNTIME
      final sdkBridge = GyawunMetadataSdkPlugin();
      runtime.addPlugin(sdkBridge);

      // 4. PREPARE HOST ENVIRONMENT
      final hostEnv = HostEnv(network: MockNetworkServiceRealCall());

      // 5. PLUGIN INSTANTIATION
      final result = runtime.executeLib(
        'package:gyawun_metadata_plugin/main.dart',
        'getPlugin',
        [$HostEnv.wrap(hostEnv)],
      );

      plugin = result as IMetadataPlugin;
    });

    test('Test getAlbum', () async {
      final album = await plugin.album.getAlbum(
        '2c053984-4645-4699-9474-d2c35c227028',
      );

      expect(album, isA<Album>());
      expect(album.id, equals("2c053984-4645-4699-9474-d2c35c227028"));
      expect(album.name, equals("Help!"));
      expect(album.artists.length, 1);
      expect(album.artists.first.name, equals("The Beatles"));
      expect(
        album.artists.first.id,
        equals("b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d"),
      );
      expect(
        album.artists.first.externalUri,
        equals(
          "https://musicbrainz.org/ws/2/artist/b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d",
        ),
      );
    });

    test('Test releases', () async {
      dynamic result = await plugin.album.releases();

      expect(result, isA<PaginatedResult<Album>>());
      expect(result.items.length, equals(1));
      expect(result.items[0].id, equals('123'));
      expect(result.items[0].name, equals('Test Album'));
      expect(result.offset, equals(0));
      expect(result.limit, equals(20));

      result = await plugin.album.releases(offset: 10, limit: 5);

      expect(result.offset, equals(10));
      expect(result.limit, equals(5));
    });
  });
}
