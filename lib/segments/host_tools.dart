import 'dart:convert';

import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_response.dart';

class HostTools {
  final HostEnv env;

  HostTools(this.env);

  Future fetchApi({
    required String baseUrl,
    required String path,
    Map<String, String> headers = const {},
    Map<String, String> query = const {},
  }) async {
    final queryString = query.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    String url = "$baseUrl$path";
    if (queryString.isNotEmpty) {
      url += "?$queryString";
    }
    final request = PluginRequest(
      url: url,
      method: 'GET',
      headers: {'Accept': 'application/json'}..addAll(headers),
    );
    print("Sending API request to $url with headers: ${request.headers}");
    final PluginResponse response = await env.network.send(request);
    print("API Response for $url: ${response.statusCode} ${response.body}");
    if (response.statusCode != 200) {
      throw Exception("API Error: ${response.statusCode} ${response.body}");
    }
    return jsonDecode(response.body);
  }
}
