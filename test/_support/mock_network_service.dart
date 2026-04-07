import 'package:gyawun_metadata_sdk/metadata/interfaces/inetwork_service.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_response.dart';

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
