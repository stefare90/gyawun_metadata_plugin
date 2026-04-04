import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class ICore {
  Future<Map<String, dynamic>?> checkUpdate(Map<String, dynamic> pluginConfig) {
    throw Exception('Method not implemented.');
  }

  String support() {
    throw Exception('Method not implemented.');
  }

  Future<void> scrobble(Map<String, dynamic> details) {
    throw Exception('Method not implemented.');
  }
}
