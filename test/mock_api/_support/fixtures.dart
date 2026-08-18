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
}
