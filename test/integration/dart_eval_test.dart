import 'dart:io';
import 'package:test/test.dart';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/eval_plugin.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata_plugin_sdk.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata_plugin_sdk_eval.dart';

class MockNetwork implements INetworkService {
  @override
  Future<PluginResponse> send(PluginRequest request) async {
    print('--- Host: Ricevuta richiesta nativa per ${request.url} ---');
    return PluginResponse(statusCode: 200, body: 'Test response');
  }
}

void main() async {
  group('Dart eval tests', () {
    setUp(() {});

    test('Test Plugin', () async {
      final compiler = Compiler();

      final pluginBridge = GyawunMetadataPluginPlugin();
      pluginBridge.configureForCompile(compiler);

      final sourcePlugin = '''
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata_plugin_sdk.dart';
import 'dart:convert';

Future<Album> testPlugin() async {
  final request = PluginRequest(url: 'https://api.test.com/album/123');
  
  final response = await MetadataHost.network.send(request);

  print(response.body);
  
  return Album(
    id: '123',
    name: 'name_album',
    artists: [],
    releaseDate: '2023-01-01',
    externalUri: '',
    totalTracks: 10,
    albumType: AlbumType.album,
  );
}
''';

      final program = compiler.compile({
        'gyawun_metadata_plugin': {
          'plugin_sdk/metadata/interfaces.dart': File(
            'lib/plugin_sdk/metadata/interfaces.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata/interfaces/inetwork_service.dart': File(
            'lib/plugin_sdk/metadata/interfaces/inetwork_service.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata/host.dart': File(
            'lib/plugin_sdk/metadata/host.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata_plugin_sdk.dart': File(
            'lib/plugin_sdk/metadata_plugin_sdk.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata/models.dart': File(
            'lib/plugin_sdk/metadata/models.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata/models/plugin_request.dart': File(
            'lib/plugin_sdk/metadata/models/plugin_request.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata/models/plugin_response.dart': File(
            'lib/plugin_sdk/metadata/models/plugin_response.dart',
          ).readAsStringSync(),
          'plugin_sdk/metadata/models/album.dart': File(
            'lib/plugin_sdk/metadata/models/album.dart',
          ).readAsStringSync(),
        },
        'my_test_plugin': {'main.dart': sourcePlugin},
      });

      final runtime = Runtime(program.write().buffer.asByteData());

      pluginBridge.configureForRuntime(runtime);

      runtime.executeLib(
        'package:gyawun_metadata_plugin/plugin_sdk/metadata/host.dart',
        'MetadataHost.setup',
        [$INetworkService.wrap(MockNetwork())],
      );

      print('Avvio del plugin...');
      final result = await runtime.executeLib(
        'package:my_test_plugin/main.dart',
        'testPlugin',
      );

      expect(result, isNotNull);
      expect(result, isA<$Instance>());

      final Album album = result.$reified;
      expect(album.id, '123');
      expect(album.name, 'name_album');
    });
  });
}
