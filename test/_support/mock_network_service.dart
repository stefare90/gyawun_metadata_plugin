import 'package:gyawun_metadata_sdk/metadata/interfaces/inetwork_service.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_response.dart';
import 'package:http/http.dart' as http;

class MockNetworkService implements INetworkService {
  @override
  Future<PluginResponse> send(PluginRequest request) async {
    print("called send with url: ${request.url}");
    return PluginResponse(
      statusCode: 200,
      body: '{"id": "123", "name": "Bytecode Success"}',
    );
  }
}

class MockNetworkServiceRealCall implements INetworkService {
  MockNetworkServiceRealCall();

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
