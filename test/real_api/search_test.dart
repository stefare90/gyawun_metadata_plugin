import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  group("Search interface test", () {
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

    void testChips(IMetadataPlugin plugin) {
      final chips = plugin.search.chips();
      expect(chips, isA<List<String>>());
      expect(chips, equals(['Tracks', 'Albums', 'Artists']));
    }

    Future<void> testTracks(IMetadataPlugin plugin) async {
      final result = await plugin.search.tracks('Help', limit: 5, offset: 0);

      expect(result, isA<PaginatedResult<Track>>());
      expect(result.limit, equals(5));
      expect(result.offset, equals(0));
      expect(result.total, greaterThan(0));
      expect(result.items, isNotEmpty);

      final track = result.items.first;
      expect(track.id, isNotEmpty);
      expect(track.name, isNotEmpty);
      expect(track.artists, isNotEmpty);
      expect(track.artists.first.name, isNotEmpty);
      expect(
        track.externalUri,
        startsWith('https://musicbrainz.org/recording/'),
      );
      expect(track.album.images, isNotEmpty);
      expect(track.album.images.first.url, contains('coverartarchive.org'));
    }

    Future<void> testAlbums(IMetadataPlugin plugin) async {
      final result = await plugin.search.albums('Help', limit: 5, offset: 0);

      expect(result, isA<PaginatedResult<Album>>());
      expect(result.limit, equals(5));
      expect(result.offset, equals(0));
      expect(result.total, greaterThan(0));
      expect(result.items, isNotEmpty);

      final album = result.items.first;
      expect(album.id, startsWith('rg:'));
      expect(album.name, isNotEmpty);
      expect(album.images, isNotEmpty);
      expect(album.artists, isNotEmpty);
    }

    Future<void> testArtists(IMetadataPlugin plugin) async {
      final result = await plugin.search.artists(
        'The Beatles',
        limit: 5,
        offset: 0,
      );

      expect(result, isA<PaginatedResult<Artist>>());
      expect(result.limit, equals(5));
      expect(result.offset, equals(0));
      expect(result.total, greaterThan(0));
      expect(result.items, isNotEmpty);

      final artist = result.items.first;
      expect(artist.id, isNotEmpty);
      expect(artist.name, isNotEmpty);
      expect(artist.externalUri, startsWith('https://musicbrainz.org/artist/'));
    }

    Future<void> testArtistImages(IMetadataPlugin plugin) async {
      final result = await plugin.search.artists(
        'Radiohead',
        limit: 5,
        offset: 0,
      );

      expect(result.items, isNotEmpty);

      bool found = false;
      for (final artist in result.items) {
        if (artist.images.isNotEmpty) {
          found = true;
          expect(artist.images.length, equals(4));
          final List<int?> widths = [];
          for (final image in artist.images) {
            widths.add(image.width);
          }
          expect(widths, equals(<int>[56, 250, 500, 1000]));
          expect(
            artist.images.first.url,
            startsWith('https://commons.wikimedia.org/wiki/Special:FilePath/'),
          );
          expect(artist.images.first.url, contains('width=56'));
        }
      }
      expect(
        found,
        isTrue,
        reason: 'A known artist (Radiohead) must expose at least one image',
      );
    }

    Future<void> testPlaylists(IMetadataPlugin plugin) async {
      final result = await plugin.search.playlists('Rock', limit: 5, offset: 0);

      expect(result, isA<PaginatedResult<Playlist>>());
      expect(result.limit, equals(5));
      expect(result.offset, equals(0));
      expect(result.total, equals(0));
      expect(result.items, isEmpty);
    }

    Future<void> testAll(IMetadataPlugin plugin) async {
      final result = await plugin.search.all('Beatles');

      expect(result, isA<SearchResponse>());
      expect(result.tracks, isNotEmpty);
      expect(result.albums, isNotEmpty);
      expect(result.artists, isNotEmpty);
      expect(result.playlists, isEmpty);

      expect(result.tracks.first.id, isNotEmpty);
      expect(result.albums.first.id, startsWith('rg:'));
      expect(result.artists.first.name, contains('Beatles'));
    }

    group("Native tests", () {
      test('Test chips', () => testChips(nativePlugin));
      test('Test tracks', () async => await testTracks(nativePlugin));
      test('Test albums', () async => await testAlbums(nativePlugin));
      test('Test artists', () async => await testArtists(nativePlugin));
      test(
        'Test artist images',
        () async => await testArtistImages(nativePlugin),
      );
      test('Test playlists', () async => await testPlaylists(nativePlugin));
      test('Test all', () async => await testAll(nativePlugin));
    });

    group("Eval tests", () {
      test('Test chips', () => testChips(evalPlugin));
      test('Test tracks', () async => await testTracks(evalPlugin));
      test('Test albums', () async => await testAlbums(evalPlugin));
      test('Test artists', () async => await testArtists(evalPlugin));
      test(
        'Test artist images',
        () async => await testArtistImages(evalPlugin),
      );
      test('Test playlists', () async => await testPlaylists(evalPlugin));
      test('Test all', () async => await testAll(evalPlugin));
    });
  });
}
