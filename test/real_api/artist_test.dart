import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  group("Artist interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;
    late IUIService mockUi;

    setUpAll(() async {
      mockUi = MockUiService();
      registerFallbackValue(FakeInputField());
      hostEnv = HostEnv(
        network: NetworkService(),
        storage: StorageService(),
        ui: mockUi,
      );
      nativePlugin = getNativePlugin(hostEnv);
      evalPlugin = getEvalPlugin(hostEnv);
    });

    Future<void> testGetArtist(IMetadataPlugin plugin) async {
      final artist = await plugin.artist.getArtist(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
      );

      expect(artist, isA<Artist>());
      expect(artist.id, equals("b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d"));
      expect(artist.name, equals("The Beatles"));
      expect(
        artist.externalUri,
        equals(
          "https://musicbrainz.org/artist/b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d",
        ),
      );
      expect(artist.images, isNotEmpty);
      expect(artist.images.length, equals(4));

      expect(
        artist.images[0].url,
        contains("commons.wikimedia.org/wiki/Special:FilePath/"),
      );
      expect(artist.images[0].width, equals(56));
      expect(artist.images[0].height, equals(56));

      expect(
        artist.images[1].url,
        contains("commons.wikimedia.org/wiki/Special:FilePath/"),
      );
      expect(artist.images[1].width, equals(250));
      expect(artist.images[1].height, equals(250));

      expect(
        artist.images[2].url,
        contains("commons.wikimedia.org/wiki/Special:FilePath/"),
      );
      expect(artist.images[2].width, equals(500));
      expect(artist.images[2].height, equals(500));

      expect(
        artist.images[3].url,
        contains("commons.wikimedia.org/wiki/Special:FilePath/"),
      );
      expect(artist.images[3].width, equals(1000));
      expect(artist.images[3].height, equals(1000));

      expect(artist.genres, isNotNull);
      expect(artist.genres, isNotEmpty);
      expect(artist.genres, contains("britpop"));
      expect(artist.genres, contains("rock"));
    }

    Future<void> testGetAlbums(IMetadataPlugin plugin) async {
      var albums = await plugin.artist.albums(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
        offset: 0,
        limit: 2,
      );

      expect(albums, isA<PaginatedResult<Album>>());
      expect(albums.offset, equals(0));
      expect(albums.limit, equals(2));
      expect(albums.items.length, equals(2));
      expect(albums.items, isA<List<Album>>());
      expect(albums.items[0].id, isNotEmpty);
      expect(albums.items[0].name, isNotEmpty);
      expect(
        albums.items[0].externalUri,
        startsWith("https://musicbrainz.org/release/"),
      );

      albums = await plugin.artist.albums(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
        offset: 2,
        limit: 1,
      );

      expect(albums, isA<PaginatedResult<Album>>());
      expect(albums.offset, equals(2));
      expect(albums.limit, equals(1));
      expect(albums.items.length, equals(1));
    }

    Future<void> testGetRelated(IMetadataPlugin plugin) async {
      PaginatedResult<Artist> related = await plugin.artist.related(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
        offset: 0,
        limit: 2,
      );

      expect(related, isA<PaginatedResult<Artist>>());
      expect(related.offset, equals(0));
      expect(related.limit, equals(2));
      expect(related.items.length, equals(2));
      expect(related.items, isA<List<Artist>>());

      final names = related.items.map((e) => e.name).toList();
      expect(names, contains("Pink Floyd"));
      expect(names, contains("The Rolling Stones"));

      expect(related.items[0].id, isNotEmpty);
      expect(related.items[0].images, isNotEmpty);
      expect(
        related.items[0].images.first.url,
        contains("commons.wikimedia.org"),
      );
      expect(related.items[0].genres, isNotEmpty);
    }

    Future<void> testGetTopTracks(IMetadataPlugin plugin) async {
      // Test di offset: 0, limit: 2 (Dovrebbe restituire "Ask Me Why" e "The Saints")
      var tracks = await plugin.artist.topTracks(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
        offset: 0,
        limit: 2,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, equals(0));
      expect(tracks.limit, equals(2));
      expect(tracks.total, equals(6));
      expect(tracks.items.length, equals(2));
      expect(tracks.items, isA<List<Track>>());

      final firstTrack = tracks.items[0];
      expect(firstTrack.id, equals("c8da403f-3c34-48b0-ae9e-7aa419df07c3"));
      expect(firstTrack.name, equals("Ask Me Why"));
      expect(firstTrack.album.name, equals("Please Please Me / Ask Me Why"));
      expect(firstTrack.artists[0].name, equals("The Beatles"));

      final secondTrack = tracks.items[1];
      expect(secondTrack.id, equals("bb0fc222-e480-48a5-89ec-a564efb3886a"));
      expect(secondTrack.name, equals("The Saints"));
      expect(secondTrack.album.name, equals("My Bonnie"));
      expect(secondTrack.artists[0].name, equals("Tony Sheridan"));

      tracks = await plugin.artist.topTracks(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
        offset: 2,
        limit: 1,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, equals(2));
      expect(tracks.limit, equals(1));
      expect(tracks.items.length, equals(1));

      final thirdTrack = tracks.items[0];
      expect(thirdTrack.id, equals("f87eb4dd-7e3c-4365-a3c8-f144696f5952"));
      expect(thirdTrack.name, equals("Love Me Do"));
      expect(thirdTrack.album.name, equals("Love Me Do"));
      expect(thirdTrack.artists[0].name, equals("The Beatles"));
    }

    group("Native tests", () {
      test('Test getArtist', () async => await testGetArtist(nativePlugin));
      test('Test albums', () async => await testGetAlbums(nativePlugin));
      test('Test related', () async => await testGetRelated(nativePlugin));
      test('Test topTracks', () async => await testGetTopTracks(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getArtist', () async => await testGetArtist(evalPlugin));
      test('Test albums', () async => await testGetAlbums(evalPlugin));
      test('Test related', () async => await testGetRelated(evalPlugin));
      test('Test topTracks', () async => await testGetTopTracks(evalPlugin));
    });
  });
}
