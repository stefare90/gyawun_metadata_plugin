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
  group("Track interface test", () {
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

    Future<void> testGetTrack(IMetadataPlugin plugin) async {
      final track = await plugin.track.getTrack(
        'f87eb4dd-7e3c-4365-a3c8-f144696f5952',
      );

      expect(track, isA<Track>());

      expect(track.id, equals("f87eb4dd-7e3c-4365-a3c8-f144696f5952"));
      expect(track.name, equals("Love Me Do"));
      expect(track.durationMs, equals(143906));
      expect(
        track.externalUri,
        equals(
          "https://musicbrainz.org/recording/f87eb4dd-7e3c-4365-a3c8-f144696f5952",
        ),
      );
      expect(track.path, isNull);

      expect(track.artists, isNotEmpty);
      expect(
        track.artists[0].id,
        equals("b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d"),
      );
      expect(track.artists[0].name, equals("The Beatles"));
      expect(
        track.artists[0].externalUri,
        equals(
          "https://musicbrainz.org/artist/b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d",
        ),
      );

      expect(track.album, isNotNull);
      expect(track.album.id, isNotEmpty);
      expect(track.album.name, isNotEmpty);
      expect(
        track.album.externalUri,
        startsWith("https://musicbrainz.org/release/"),
      );
      expect(track.album.releaseDate, isNotEmpty);
      expect(track.album.albumType, equals(AlbumType.album));

      expect(track.album.artists, isNotEmpty);
      expect(track.album.artists[0].name, equals("The Beatles"));
    }

    Future<void> testRadio(IMetadataPlugin plugin) async {
      try {
        final tracks = await plugin.track.radio(
          'f87eb4dd-7e3c-4365-a3c8-f144696f5952',
        );

        expect(tracks, isA<List<Track>>());
        expect(tracks, isNotEmpty);
        expect(tracks[0].id, isNotEmpty);
        expect(tracks[0].name, isNotEmpty);
        expect(tracks[0].artists, isNotEmpty);
        expect(tracks[0].album.name, isNotEmpty);
      } catch (e) {
        final String errorMsg = e is $Value
            ? e.$value.toString()
            : e.toString();

        if (errorMsg.contains("LB Radio currently disabled")) {
          print(
            "⚠️ Warning: Skipping testRadio because ListenBrainz Radio is currently disabled due to high server load.",
          );
        } else {
          rethrow;
        }
      }
    }

    group("Native tests", () {
      test('Test getTrack', () async => await testGetTrack(nativePlugin));
      test('Test radio', () async => await testRadio(nativePlugin));
    });

    group("Eval tests", () {
      test('Test getTrack', () async => await testGetTrack(evalPlugin));
      test('Test radio', () async => await testRadio(evalPlugin));
    });
  });
}
