import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_plugin/segments/wikimedia_images.dart';
import 'package:gyawun_metadata_sdk/metadata/models/artist.dart';
import 'package:gyawun_metadata_sdk/metadata/models/image.dart';

/// Resolves artist images from Wikidata with a single bulk SPARQL query per
/// page, backed by an in-memory per-MBID cache.
///
/// Shared by search, related artists and the saved-artists library so the same
/// artist is never queried twice within a plugin session.
class WikidataArtistImages {
  static const String sparqlUrl = 'https://query.wikidata.org';

  final HostTools _host;
  final Map<String, List<Image>> _cache = <String, List<Image>>{};

  WikidataArtistImages(this._host);

  /// Returns the images for each requested MusicBrainz artist id, querying
  /// Wikidata only for the ids that are not already cached. Ids without a
  /// Wikidata image are cached as empty lists (negative cache).
  Future<Map<String, List<Image>>> resolve(List<String> mbids) async {
    final Map<String, List<Image>> result = <String, List<Image>>{};
    final List<String> missing = <String>[];

    for (final String id in mbids) {
      final List<Image>? cached = _cache[id];
      if (cached != null) {
        result[id] = cached;
      } else if (!missing.contains(id)) {
        missing.add(id);
      }
    }

    if (missing.isNotEmpty) {
      final Map<String, List<Image>> fetched = await _fetch(missing);
      for (final String id in missing) {
        List<Image> images = <Image>[];
        final List<Image>? found = fetched[id];
        if (found != null) {
          images = found;
        }
        _cache[id] = images;
        result[id] = images;
      }
    }

    return result;
  }

  /// Rebuilds [items] with their resolved images, preserving every other field.
  Future<List<Artist>> enrich(List<Artist> items) async {
    final List<String> ids = <String>[];
    for (final Artist artist in items) {
      if (!ids.contains(artist.id)) {
        ids.add(artist.id);
      }
    }

    final Map<String, List<Image>> imagesMap = await resolve(ids);

    final List<Artist> result = <Artist>[];
    for (final Artist artist in items) {
      List<Image> images = <Image>[];
      final List<Image>? found = imagesMap[artist.id];
      if (found != null) {
        images = found;
      }
      result.add(
        Artist(
          id: artist.id,
          name: artist.name,
          externalUri: artist.externalUri,
          images: images,
          genres: artist.genres,
          followers: artist.followers,
        ),
      );
    }
    return result;
  }

  /// Runs one SPARQL query for all the given MusicBrainz artist ids and maps
  /// each returned Wikidata image to the four standard image sizes.
  ///
  /// Uses [HostTools.fetchApiOrNull] because this enrichment is optional and
  /// best-effort: the helper returns `null` on a non-200 status and on a
  /// malformed/empty body. An HTTP error therefore degrades to empty images;
  /// a *transport* error (timeout/DNS/TLS) still propagates, because
  /// `dart_eval` 0.8.5 cannot route an async Future error into the plugin's
  /// `try/catch`. The robust fix lives at the host/SDK boundary.
  Future<Map<String, List<Image>>> _fetch(List<String> mbids) async {
    final Map<String, List<Image>> result = <String, List<Image>>{};
    if (mbids.isEmpty) {
      return result;
    }

    String values = '';
    for (final String mbid in mbids) {
      values = '$values"$mbid" ';
    }
    final String sparql =
        'SELECT ?mbid ?image WHERE { VALUES ?mbid { $values} '
        '?artist wdt:P434 ?mbid . ?artist wdt:P18 ?image . }';

    final data = await _host.fetchApiOrNull(
      baseUrl: sparqlUrl,
      path: '/sparql',
      query: {'query': sparql, 'format': 'json'},
    );

    if (data == null || data is! Map) {
      return result;
    }
    final Map map = data;

    final rawResults = map['results'];
    if (rawResults == null || rawResults is! Map) {
      return result;
    }
    final Map results = rawResults;

    final rawBindings = results['bindings'];
    if (rawBindings == null || rawBindings is! List) {
      return result;
    }

    for (final bObj in rawBindings) {
      if (bObj != null && bObj is Map) {
        final Map binding = bObj;
        final rawMbid = binding['mbid'];
        final rawImage = binding['image'];
        if (rawMbid != null && rawMbid is Map) {
          if (rawImage != null && rawImage is Map) {
            final Map mbidObj = rawMbid;
            final Map imageObj = rawImage;
            final rawMbidValue = mbidObj['value'];
            final rawImageValue = imageObj['value'];
            if (rawMbidValue != null && rawMbidValue is String) {
              if (rawImageValue != null && rawImageValue is String) {
                if (!result.containsKey(rawMbidValue)) {
                  final List<Image> images = WikimediaImages.fromImageUri(
                    rawImageValue,
                  );
                  if (images.isNotEmpty) {
                    result[rawMbidValue] = images;
                  }
                }
              }
            }
          }
        }
      }
    }

    return result;
  }
}
