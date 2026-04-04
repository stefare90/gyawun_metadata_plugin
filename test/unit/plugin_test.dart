import 'package:gyawun_metadata_plugin/plugin_sdk/metadata_plugin_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:test/test.dart';

class MockNetworkService implements INetworkService {
  MockNetworkService();

  @override
  Future<PluginResponse> send(PluginRequest request) async {
    final finalHeaders = {'User-Agent': 'Gyawun/1.0.0', ...request.headers};

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
  group('A group of tests', () {
    final awesome = MusicbrainzPlugin();
    final http.Client client = http.Client();

    setUp(() {
      MetadataHost.network = MockNetworkService();
    });

    test('Test get Album', () async {
      expect(await awesome.album.getAlbum("..."), isA<Map>());
    });
  });
}
