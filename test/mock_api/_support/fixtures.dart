class Fixtures {
  static const String albumHelp = '''
  {
    "id": "123",
    "title": "Help!",
    "date": "1965-08-06",
    "artist-credit":[{"artist": {"id": "456", "name": "The Beatles"}}],
    "release-group": {
      "id": "rg-help-123",
      "primary-type": "Album"
    },
    "media": [
      {
        "track-count": 14
      }
    ],
    "cover-art-archive": {
      "front": true,
      "darkened": false,
      "count": 6,
      "artwork": true,
      "back": true
    }
  }
  ''';

  static const String releaseGroupLookup = '''
  {
    "releases": [
      {
        "id": "123",
        "title": "Help!"
      }
    ]
  }
  ''';

  static const String recordingsHelp = '''
  {
    "recording-count": 1,
    "recordings": [
      {
        "id": "rec-1",
        "title": "Help!",
        "length": 138000,
        "artist-credit": [{"artist": {"id": "456", "name": "The Beatles"}}]
      }
    ]
  }
  ''';

  /// MusicBrainz artist search response for a single known artist.
  static const String searchArtistsRadiohead = '''
  {
    "count": 1,
    "artists": [
      {
        "id": "radiohead-mbid",
        "name": "Radiohead",
        "tags": [{"name": "alternative rock"}]
      }
    ]
  }
  ''';

  /// MusicBrainz artist search response for an artist with no Wikidata image.
  static const String searchArtistsNoImage = '''
  {
    "count": 1,
    "artists": [
      {
        "id": "no-image-mbid",
        "name": "Obscure Artist"
      }
    ]
  }
  ''';

  /// Wikidata SPARQL response with one P18 image for `radiohead-mbid`.
  /// The URI is deliberately `http://` to also exercise the https upgrade.
  static const String sparqlArtistImage = '''
  {
    "head": {"vars": ["mbid", "image"]},
    "results": {
      "bindings": [
        {
          "mbid": {"type": "literal", "value": "radiohead-mbid"},
          "image": {
            "type": "uri",
            "value": "http://commons.wikimedia.org/wiki/Special:FilePath/Radiohead%20composite.jpg"
          }
        }
      ]
    }
  }
  ''';

  /// Wikidata SPARQL response with no P18 image (negative result).
  static const String sparqlNoImage = '''
  {
    "head": {"vars": ["mbid", "image"]},
    "results": {
      "bindings": []
    }
  }
  ''';
}
