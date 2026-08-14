import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

class ArtistTestCase {
  final String name;
  final String mbid;

  const ArtistTestCase({required this.name, required this.mbid});
}

void main() async {
  group("Artist interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;
    late IUIService mockUi;

    const testArtists = [
      ArtistTestCase(
        name: 'Queen',
        mbid: '0383dadf-2a4e-4d10-a46a-e9e041da8eb3',
      ),
      ArtistTestCase(
        name: 'Bee Gees',
        mbid: 'bf0f7e29-dfe1-416c-b5c6-f9ebc19ea810',
      ),
      ArtistTestCase(
        name: 'Michael Jackson',
        mbid: 'f27ec8db-af05-4f36-916e-3d57f91ecf5e',
      ),
    ];

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

    Future<void> testArtistTopTracks(
      IMetadataPlugin plugin,
      ArtistTestCase testCase,
    ) async {
      final result = await plugin.artist.topTracks(
        testCase.mbid,
        offset: 0,
        limit: 10,
      );
      expect(result, isA<PaginatedResult<Track>>());
      expect(
        result.items,
        isNotEmpty,
        reason: 'Top tracks for ${testCase.name} should not be empty',
      );
      expect(result.items.length, greaterThan(0));
      expect(result.total, greaterThan(0));
      expect(result.offset, equals(0));
      expect(result.limit, equals(10));
      final firstTrack = result.items.first;
      expect(firstTrack.id, isNotEmpty);
      expect(firstTrack.name, isNotEmpty);
      expect(firstTrack.durationMs, greaterThan(0));
      expect(
        firstTrack.externalUri,
        startsWith('https://musicbrainz.org/recording/'),
      );
      expect(firstTrack.externalUri, contains(firstTrack.id));
      expect(firstTrack.artists, isNotEmpty);
      final hasMatchingArtist = firstTrack.artists.any(
        (a) => a.id == testCase.mbid,
      );
      expect(
        hasMatchingArtist,
        isTrue,
        reason:
            'Track "${firstTrack.name}" should contain artist with ID ${testCase.mbid}',
      );
      expect(firstTrack.album, isNotNull);
      expect(firstTrack.album.name, isNotEmpty);
      expect(firstTrack.album.albumType, isA<AlbumType>());
      for (final track in result.items) {
        expect(track.id, isNotEmpty);
        expect(track.name, isNotEmpty);
        expect(track.externalUri, contains('musicbrainz.org/recording/'));
        expect(track.artists, isNotEmpty);
        expect(
          track.artists.any((a) => a.id == testCase.mbid),
          isTrue,
          reason:
              'Track "${track.name}" should contain artist ID ${testCase.mbid}',
        );
      }
    }

    group("Native tests", () {
      test('Test getArtist', () async => await testGetArtist(nativePlugin));
      test('Test albums', () async => await testGetAlbums(nativePlugin));
      test('Test related', () async => await testGetRelated(nativePlugin));

      for (final testCase in testArtists) {
        test(
          'TopTracks for ${testCase.name}',
          () async => await testArtistTopTracks(nativePlugin, testCase),
        );
      }
    });
    group("Eval tests", () {
      test('Test getArtist', () async => await testGetArtist(evalPlugin));
      test('Test albums', () async => await testGetAlbums(evalPlugin));
      test('Test related', () async => await testGetRelated(evalPlugin));

      for (final testCase in testArtists) {
        test(
          'TopTracks for ${testCase.name}',
          () async => await testArtistTopTracks(evalPlugin, testCase),
        );
      }
    });
  });
}
