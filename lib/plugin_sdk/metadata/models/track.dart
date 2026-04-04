import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class Track {
  final String id;
  final String name;
  final String externalUri;
  final List<Artist> artists;
  final Album album;
  final int durationMs;
  final String? path;

  Track({
    required this.id,
    required this.name,
    required this.externalUri,
    this.artists = const [],
    required this.album,
    required this.durationMs,
    this.path,
  });
}
