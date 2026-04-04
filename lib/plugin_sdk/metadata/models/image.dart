import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class Image {
  final String url;
  final int? width;
  final int? height;

  Image({required this.url, this.width, this.height});
}
