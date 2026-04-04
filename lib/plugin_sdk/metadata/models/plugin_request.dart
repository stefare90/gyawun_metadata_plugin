import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class PluginRequest {
  final String url;
  final String method;
  final Map headers;
  final String? body;

  PluginRequest({
    required this.url,
    this.method = 'GET',
    this.headers = const {},
    this.body,
  });
}
