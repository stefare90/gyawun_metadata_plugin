import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

class AlbumTestCase {
  final String id;
  final String name;
  final String artistName;
  final String releaseDate;
  final int totalTracks;

  const AlbumTestCase({
    required this.id,
    required this.name,
    required this.artistName,
    required this.releaseDate,
    required this.totalTracks,
  });
}

void main() async {
  group("Album interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;
    late IUIService mockUi;

    const testAlbums = [
      AlbumTestCase(
        id: '2c053984-4645-4699-9474-d2c35c227028',
        name: 'Help!',
        artistName: 'The Beatles',
        releaseDate: '1965-08-06',
        totalTracks: 14,
      ),
      AlbumTestCase(
        id: '1de4099e-a41a-4ead-bb53-f45226bf778c',
        name: 'Got to Be There',
        artistName: 'Michael Jackson',
        releaseDate: '1972-01-24',
        totalTracks: 11,
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

    Future<void> testGetAlbum(
      IMetadataPlugin plugin,
      AlbumTestCase testCase,
    ) async {
      final album = await plugin.album.getAlbum(testCase.id);

      expect(album, isA<Album>());
      expect(album.id, equals(testCase.id));
      expect(album.name, equals(testCase.name));
      expect(album.artists, isNotEmpty);
      expect(album.artists.first.name, equals(testCase.artistName));
      expect(
        album.releaseDate,
        startsWith(testCase.releaseDate.split('-').first),
      );
      expect(album.totalTracks, equals(testCase.totalTracks));
    }

    Future<void> testGetAlbumTracks(
      IMetadataPlugin plugin,
      AlbumTestCase testCase,
    ) async {
      final tracks = await plugin.album.tracks(
        testCase.id,
        offset: 0,
        limit: 20,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.items, isNotEmpty);
      expect(tracks.items.length, greaterThan(0));
      expect(tracks.total, equals(testCase.totalTracks));

      final firstTrack = tracks.items.first;
      expect(firstTrack.id, isNotEmpty);
      expect(firstTrack.name, isNotEmpty);
      expect(firstTrack.durationMs, greaterThan(0));
      expect(firstTrack.album.name, equals(testCase.name));
      expect(firstTrack.artists, isNotEmpty);
      expect(firstTrack.artists.first.name, equals(testCase.artistName));
    }

    group("Native tests - getAlbum", () {
      for (final testCase in testAlbums) {
        test(
          'getAlbum for ${testCase.name} (${testCase.id})',
          () async => await testGetAlbum(nativePlugin, testCase),
        );
      }
    });

    group("Native tests - tracks", () {
      for (final testCase in testAlbums) {
        test(
          'tracks for ${testCase.name} (${testCase.id})',
          () async => await testGetAlbumTracks(nativePlugin, testCase),
        );
      }
    });

    group("Eval tests - getAlbum", () {
      for (final testCase in testAlbums) {
        test(
          'getAlbum for ${testCase.name} (${testCase.id})',
          () async => await testGetAlbum(evalPlugin, testCase),
        );
      }
    });

    group("Eval tests - tracks", () {
      for (final testCase in testAlbums) {
        test(
          'tracks for ${testCase.name} (${testCase.id})',
          () async => await testGetAlbumTracks(evalPlugin, testCase),
        );
      }
    });
  });
}
