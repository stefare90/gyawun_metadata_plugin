import 'dart:convert';

import 'package:gyawun_metadata_sdk/metadata/interfaces/inetwork_service.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/istorage_service.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../common/setup.dart';
import '_support/fakes.dart';
import '_support/fixtures.dart';
import '_support/mocks.dart';

void main() {
  group("Album interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;
    late INetworkService mockNetwork;
    late IUIService mockUi;
    late IStorageService mockStorage;

    setUpAll(() {
      registerFallbackValues();
      mockNetwork = MockNetworkService();
      mockStorage = MockStorage();
      mockUi = MockUiService();
      hostEnv = HostEnv(network: mockNetwork, storage: mockStorage, ui: mockUi);
      nativePlugin = getNativePlugin(hostEnv);
      evalPlugin = getEvalPlugin(hostEnv);
    });

    Future<void> testGetAlbum(IMetadataPlugin plugin) async {
      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/release/123?inc=artist-credits%2Brecordings&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async => PluginResponse(statusCode: 200, body: Fixtures.albumHelp),
      );

      final album = await plugin.album.getAlbum('123');

      final albumJson = jsonDecode(Fixtures.albumHelp);
      expect(album.name, equals(albumJson['title']));
      expect(album.id, equals(albumJson['id']));
      expect(album.releaseDate, equals(albumJson['date']));
      expect(album.totalTracks, equals(albumJson['media'][0]['track-count']));
      expect(album.artists.length, equals(1));
      expect(
        album.artists[0].name,
        equals(albumJson['artist-credit'][0]['artist']['name']),
      );
      expect(album.images.length, equals(2));
      expect(
        album.images[0].url,
        equals("https://coverartarchive.org/release/123/front-250.jpg"),
      );
      expect(album.images[0].width, equals(250));
      expect(album.images[0].height, equals(250));
      expect(
        album.images[1].url,
        equals("https://coverartarchive.org/release/123/front-500.jpg"),
      );
      expect(album.images[1].width, equals(500));
      expect(album.images[1].height, equals(500));
      verify(() => mockNetwork.send(any())).called(1);
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testGetAlbum(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testGetAlbum(evalPlugin));
    });
  });
}
