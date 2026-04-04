import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class BrowseSection<T> {
  final String id;
  final String title;
  final String externalUri;
  final bool browseMore;
  final List<T> items;

  BrowseSection({
    required this.id,
    required this.title,
    required this.externalUri,
    required this.browseMore,
    required this.items,
  });
}
