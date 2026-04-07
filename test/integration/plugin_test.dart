import 'dart:io';
import 'package:gyawun_metadata_sdk/eval/eval_plugin.dart';
import 'package:gyawun_metadata_sdk/eval/host_env.eval.dart';
import 'package:test/test.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';

import '../_support/mock_network_service.dart';

void main() async {
  group('Plugin Integration Test (Bytecode)', () {
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
      final hostEnv = HostEnv(network: MockNetworkService());

      // 5. PLUGIN INSTANTIATION
      final result = runtime.executeLib(
        'package:gyawun_metadata_plugin/main.dart',
        'getPlugin',
        [$HostEnv.wrap(hostEnv)],
      );

      plugin = result as IMetadataPlugin;
    });

    test('getAlbum should return a reified Album from bytecode', () async {
      final album = await plugin.album.getAlbum('123');

      expect(album, isA<Album>());
      expect(album.id, equals('123'));
      expect(album.name, equals('Test Album'));
    });
  });
}
