import 'package:gyawun_metadata_sdk/metadata/models/image.dart';

/// Shared helper that builds the four standard [Image] sizes
/// (56 / 250 / 500 / 1000) for a Wikimedia Commons file.
///
/// Both image discovery paths funnel through this class so the generated
/// URLs stay identical:
/// - the MusicBrainz artist lookup path (`wbgetclaims` P18 datavalue, a raw
///   file name);
/// - the search bulk path (Wikidata SPARQL `?image` URI, already encoded).
class WikimediaImages {
  static const List<int> widths = <int>[56, 250, 500, 1000];
  static const String _prefix =
      'https://commons.wikimedia.org/wiki/Special:FilePath/';
  static const String _marker = 'Special:FilePath/';

  /// Builds the four sizes from a raw Wikidata P18 file name
  /// (e.g. `RadioheadO2211125 composite.jpg`).
  static List<Image> fromFileName(String fileName) {
    if (fileName.isEmpty) {
      return <Image>[];
    }
    return _build(Uri.encodeComponent(fileName));
  }

  /// Builds the four sizes from a Wikimedia Commons `Special:FilePath`
  /// URI returned by SPARQL. The file name is already percent-encoded, so it
  /// is used as-is (re-encoding would double-escape it).
  static List<Image> fromImageUri(String uri) {
    if (uri.isEmpty) {
      return <Image>[];
    }
    String working = uri;
    if (working.startsWith('http://')) {
      working = 'https://${working.substring(7)}';
    }
    final int markerIndex = working.indexOf(_marker);
    if (markerIndex < 0) {
      return <Image>[];
    }
    String encodedName = working.substring(markerIndex + _marker.length);
    final int queryIndex = encodedName.indexOf('?');
    if (queryIndex >= 0) {
      encodedName = encodedName.substring(0, queryIndex);
    }
    return _build(encodedName);
  }

  static List<Image> _build(String encodedName) {
    final List<Image> images = <Image>[];
    if (encodedName.isEmpty) {
      return images;
    }
    for (final int w in widths) {
      images.add(
        Image(url: '$_prefix$encodedName?width=$w', width: w, height: w),
      );
    }
    return images;
  }
}
