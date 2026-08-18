import 'package:gyawun_metadata_sdk/metadata/interfaces/inetwork_service.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_response.dart';
import 'package:http/http.dart' as http;

class NetworkService implements INetworkService {
  final int maxAttempts;

  NetworkService({this.maxAttempts = 5});

  @override
  Future<PluginResponse> send(PluginRequest request) async {
    final finalHeaders = {'User-Agent': 'Gyawun/1.0.0'}
      ..addAll(request.headers);

    final uri = Uri.parse(request.url);
    http.Response? response;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      await Future.delayed(const Duration(milliseconds: 1000));

      if (request.method.toUpperCase() == 'POST') {
        response = await http.post(
          uri,
          headers: finalHeaders,
          body: request.body,
        );
      } else {
        response = await http.get(uri, headers: finalHeaders);
      }

      if (response.statusCode != 503 || attempt == maxAttempts) {
        break;
      }

      print(
        '⚠️ HTTP 503 (Service Unavailable) for $uri. Retry $attempt of $maxAttempts...',
      );
    }

    return PluginResponse(
      statusCode: response!.statusCode,
      body: response.body,
    );
  }
}
