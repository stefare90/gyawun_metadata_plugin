import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';

import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class Artist {
  final String id;
  final String name;
  final String externalUri;
  final List<Image> images;
  final List<String>? genres;
  final int? followers;

  Artist({
    required this.id,
    required this.name,
    required this.externalUri,
    this.images = const [],
    this.genres,
    this.followers,
  });
}
