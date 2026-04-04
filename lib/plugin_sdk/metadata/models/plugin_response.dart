import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class PluginResponse {
  final int statusCode;
  final String body;

  PluginResponse({required this.statusCode, required this.body});
}
