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
      expect(
        album.artists.first.id,
        equals("b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d"),
      );
      expect(
        album.artists.first.externalUri,
        equals(
          "https://musicbrainz.org/artist/b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d",
        ),
      );
      expect(album.images.length, 2);
      expect(
        album.images[0].url,
        equals(
          "http://coverartarchive.org/release/2c053984-4645-4699-9474-d2c35c227028/6119756270-250.jpg",
        ),
      );
      expect(album.images[0].width, equals(250));
      expect(album.images[0].height, equals(250));
      expect(
        album.images[1].url,
        equals(
          "http://coverartarchive.org/release/2c053984-4645-4699-9474-d2c35c227028/6119756270-500.jpg",
        ),
      );
      expect(album.images[1].width, equals(500));
      expect(album.images[1].height, equals(500));
      expect(album.releaseDate, equals("1965-08-06"));
    }

    Future<void> testGetTracks(IMetadataPlugin plugin) async {
      var tracks = await plugin.album.tracks(
        '2c053984-4645-4699-9474-d2c35c227028',
        offset: 0,
        limit: 2,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, 0);
      expect(tracks.limit, 2);
      expect(tracks.total, 2);
      expect(tracks.items.length, 2);
      expect(tracks.items, isA<List<Track>>());
      expect(tracks.items[0].album.name, equals("Help!"));
      expect(tracks.items[0].artists[0].name, equals("The Beatles"));
      expect(tracks.items[0].name, equals("Another Girl"));
      expect(tracks.items[0].durationMs, 128000);
      expect(
        tracks.items[0].id,
        equals("42bc157f-2696-4337-8634-36e676c4ab8e"),
      );
      expect(
        tracks.items[0].externalUri,
        equals(
          "https://musicbrainz.org//recording/42bc157f-2696-4337-8634-36e676c4ab8e",
        ),
      );
      expect(tracks.items[1].album.name, equals("Help!"));
      expect(tracks.items[1].artists[0].name, equals("The Beatles"));
      expect(tracks.items[1].name, equals("Act Naturally"));
      expect(tracks.items[1].durationMs, 153000);
      expect(
        tracks.items[1].id,
        equals("f59e9c88-986a-4b63-b10e-ee88139d4f81"),
      );
      expect(
        tracks.items[1].externalUri,
        equals(
          "https://musicbrainz.org//recording/f59e9c88-986a-4b63-b10e-ee88139d4f81",
        ),
      );

      tracks = await plugin.album.tracks(
        '2c053984-4645-4699-9474-d2c35c227028',
        offset: 2,
        limit: 1,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, 2);
      expect(tracks.limit, 1);
      expect(tracks.total, 1);
      expect(tracks.items.length, 1);
      expect(tracks.items, isA<List<Track>>());
      expect(tracks.items[0].album.name, equals("Help!"));
      expect(tracks.items[0].artists[0].name, equals("The Beatles"));
      expect(tracks.items[0].name, equals("Dizzy Miss Lizzy"));
      expect(tracks.items[0].durationMs, 174266);
      expect(
        tracks.items[0].id,
        equals("e75e4b16-63ed-4739-a084-7c92d219c099"),
      );
      expect(
        tracks.items[0].externalUri,
        equals(
          "https://musicbrainz.org//recording/e75e4b16-63ed-4739-a084-7c92d219c099",
        ),
      );
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
