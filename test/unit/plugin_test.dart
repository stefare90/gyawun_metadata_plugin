import 'package:gyawun_metadata_sdk/metadata/interfaces/inetwork_service.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:test/test.dart';

class MockNetworkService implements INetworkService {
  MockNetworkService();

  @override
  Future<PluginResponse> send(PluginRequest request) async {
    final finalHeaders = {'User-Agent': 'Gyawun/1.0.0'};

    final uri = Uri.parse(request.url);
    http.Response requestFuture;

    if (request.method.toUpperCase() == 'POST') {
      requestFuture = await http.post(
        uri,
        headers: finalHeaders,
        body: request.body,
      );
    } else {
      requestFuture = await http.get(uri, headers: finalHeaders);
    }

    final pluginResponse = PluginResponse(
      statusCode: requestFuture.statusCode,
      body: requestFuture.body,
    );

    return pluginResponse;
  }
}

void main() {
  group('IAlbum tests', () {
    HostEnv hostEnv = HostEnv(network: MockNetworkService());
    final awesome = MusicbrainzPlugin(hostEnv: hostEnv);
    final http.Client client = http.Client();

    setUp(() {});

    test('Test get Album', () async {
      final result = await awesome.album.getAlbum("...");
      expect(result, isA<Album>());
      expect(result.id, equals("123"));
      expect(result.name, equals("Test Album"));
    });
  });
}
