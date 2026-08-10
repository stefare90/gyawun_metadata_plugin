import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  group("Album interface test", () {
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

    Future<void> testGetAlbum(IMetadataPlugin plugin) async {
      final album = await plugin.album.getAlbum(
        '2c053984-4645-4699-9474-d2c35c227028',
      );

      expect(album, isA<Album>());
      expect(album.id, equals("2c053984-4645-4699-9474-d2c35c227028"));
      expect(album.name, equals("Help!"));
      expect(album.artists.length, 1);
      expect(album.artists.first.name, equals("The Beatles"));
      expect(album.releaseDate, equals("1965-08-06"));
      expect(album.totalTracks, equals(14));
    }

    Future<void> testGetTracks(IMetadataPlugin plugin) async {
      var tracks = await plugin.album.tracks(
        '2c053984-4645-4699-9474-d2c35c227028',
        offset: 0,
        limit: 2,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, equals(0));
      expect(tracks.limit, equals(2));
      expect(tracks.items.length, equals(2));
      expect(tracks.total, equals(14));
      expect(tracks.items[0].album.name, equals("Help!"));
      expect(tracks.items[0].artists[0].name, equals("The Beatles"));
      expect(tracks.items[0].name, equals("Another Girl"));

      tracks = await plugin.album.tracks(
        '2c053984-4645-4699-9474-d2c35c227028',
        offset: 2,
        limit: 1,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, equals(2));
      expect(tracks.limit, equals(1));
      expect(tracks.items.length, equals(1));
      expect(tracks.total, equals(14));
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testGetAlbum(nativePlugin));
      test('Test getTracks', () async => await testGetTracks(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testGetAlbum(evalPlugin));
      test('Test getTracks', () async => await testGetTracks(evalPlugin));
    });
  });
}
