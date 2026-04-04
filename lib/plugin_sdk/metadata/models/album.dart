import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
enum AlbumType { album, single, compilation }

@Bind()
class Album {
  final String id;
  final String name;
  final List<Artist> artists;
  final List<Image> images;
  final String releaseDate;
  final String externalUri;
  final int totalTracks;
  final AlbumType albumType;
  final String? recordLabel;
  final List<String>? genres;

  Album({
    required this.id,
    required this.name,
    required List artists,
    List images = const [],
    required this.releaseDate,
    required this.externalUri,
    required this.totalTracks,
    required this.albumType,
    this.recordLabel,
    List? genres,
  }) : artists = List<Artist>.from(artists),
       images = List<Image>.from(images),
       genres = genres?.cast<String>();
}
