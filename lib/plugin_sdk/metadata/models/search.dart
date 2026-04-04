import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class SearchResponse {
  final List<Album> albums;
  final List<Artist> artists;
  final List<Playlist> playlists;
  final List<Track> tracks;

  SearchResponse({
    required this.albums,
    required this.artists,
    required this.playlists,
    required this.tracks,
  });
}
