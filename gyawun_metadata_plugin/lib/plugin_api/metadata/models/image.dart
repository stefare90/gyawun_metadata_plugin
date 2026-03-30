class Image {
  final String url;
  final int? width;
  final int? height;

  Image({required this.url, this.width, this.height});

  // toJson
  Map<String, dynamic> toJson() {
    return {"url": url, "width": width, "height": height};
  }

  // fromJson
  factory Image.fromJson(Map<String, dynamic> json) {
    if (json["url"] is! String) {
      throw Exception("Invalid Image: url missing");
    }
    return Image(
      url: json["url"],
      width: json["width"],
      height: json["height"],
    );
  }
}
