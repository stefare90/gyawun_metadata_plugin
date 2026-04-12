class Fixtures {
  static const String albumHelp = '''
  {
    "id": "123",
    "title": "Help!",
    "date": "1965-08-06",
    "artist-credit":[{"artist": {"id": "456", "name": "The Beatles"}}]
  }
  ''';

  static const String albumHelpCover = '''
  {
    "images": 
    [
      {
        "front": true,
        "image": "https://coverartarchive.org/release/123/front.jpg",
        "thumbnails": 
        {
          "small": "https://coverartarchive.org/release/123/front-250.jpg",
          "large": "https://coverartarchive.org/release/123/front-500.jpg"
        }
      }
    ]
  }
  ''';
}
