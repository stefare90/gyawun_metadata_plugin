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

      expect(artist.images[0].url, startsWith("https://"));
      expect(artist.images[0].width, equals(56));
      expect(artist.images[0].height, equals(56));

      expect(artist.images[1].url, startsWith("https://"));
      expect(artist.images[1].width, equals(250));
      expect(artist.images[1].height, equals(250));

      expect(artist.images[2].url, startsWith("https://"));
      expect(artist.images[2].width, equals(500));
      expect(artist.images[2].height, equals(500));

      expect(artist.images[3].url, startsWith("https://"));
      expect(artist.images[3].width, equals(1000));
      expect(artist.images[3].height, equals(1000));

      expect(artist.genres, isNotNull);
      expect(artist.genres, isNotEmpty);
      expect(artist.genres, contains("britpop"));
      expect(artist.genres, contains("rock"));
      expect(artist.genres, contains("rock and roll"));
      expect(artist.genres, contains("psychedelic pop"));
      expect(artist.genres, contains("psychedelic rock"));
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
      expect(albums.total, equals(692));
      expect(albums.items.length, equals(2));
      expect(albums.items, isA<List<Album>>());
      expect(albums.items[0].id, isNotEmpty);
      expect(albums.items[0].name, isNotEmpty);
      expect(
        albums.items[0].externalUri,
        startsWith("https://musicbrainz.org/release-group/"),
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
      expect(related.items[0].images.first.url, startsWith("https://"));
      expect(related.items[0].genres, isNotEmpty);

      related = await plugin.artist.related(
        'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
        offset: 2,
        limit: 2,
      );

      expect(related, isA<PaginatedResult<Artist>>());
      expect(related.offset, equals(2));
      expect(related.limit, equals(2));
      expect(related.items.length, equals(2));
      expect(related.items, isA<List<Artist>>());

      final names2 = related.items.map((e) => e.name).toList();
      expect(names2, contains("Queen"));
      expect(names2, contains("David Bowie"));
    }

    Future<void> testGetTopTracks(IMetadataPlugin plugin) async {
      try {
        var tracks = await plugin.artist.topTracks(
          'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
          offset: 0,
          limit: 2,
        );

        expect(tracks, isA<PaginatedResult<Track>>());
        expect(tracks.offset, equals(0));
        expect(tracks.limit, equals(2));
        expect(tracks.items.length, equals(2));
        expect(tracks.items, isA<List<Track>>());

        expect(tracks.items[0].id, isNotEmpty);
        expect(tracks.items[0].name, isNotEmpty);
        expect(tracks.items[0].album, isNotNull);
        expect(tracks.items[0].album!.id, isNotEmpty);
        expect(tracks.items[0].album!.name, isNotEmpty);
        expect(tracks.items[0].artists, isNotEmpty);
        expect(tracks.items[0].artists[0].name, equals("The Beatles"));
        expect(
          tracks.items[0].externalUri,
          startsWith("https://musicbrainz.org/recording/"),
        );

        tracks = await plugin.artist.topTracks(
          'b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d',
          offset: 2,
          limit: 1,
        );

        expect(tracks, isA<PaginatedResult<Track>>());
        expect(tracks.offset, equals(2));
        expect(tracks.limit, equals(1));
        expect(tracks.items.length, equals(1));
      } catch (e) {
        final String errorMsg = e is $Value
            ? e.$value.toString()
            : e.toString();
        if (errorMsg.contains("Popularity API currently disabled")) {
          print(
            "⚠️ Warning: Skipping testGetTopTracks because API currently disabled.",
          );
        } else {
          rethrow;
        }
      }
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
