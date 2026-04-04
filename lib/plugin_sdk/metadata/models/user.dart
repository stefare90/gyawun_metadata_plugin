import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class User {
  final String id;
  final String name;
  final List<Image> images;
  final String externalUri;

  User({
    required this.id,
    required this.name,
    this.images = const [],
    required this.externalUri,
  });
}
