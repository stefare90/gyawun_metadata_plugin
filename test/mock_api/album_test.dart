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
                  'https://musicbrainz.org/ws/2/release/123?inc=artist-credits&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async => PluginResponse(statusCode: 200, body: Fixtures.albumHelp),
      );

      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) => req.url == 'https://coverartarchive.org/release/123',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async =>
            PluginResponse(statusCode: 200, body: Fixtures.albumHelpCover),
      );

      final album = await plugin.album.getAlbum('123');

      final albumJson = jsonDecode(Fixtures.albumHelp);
      final albumCoverJson = jsonDecode(Fixtures.albumHelpCover);
      expect(album.name, equals(albumJson['title']));
      expect(album.id, equals(albumJson['id']));
      expect(album.releaseDate, equals(albumJson['date']));
      expect(album.artists.length, equals(1));
      expect(
        album.artists[0].name,
        equals(albumJson['artist-credit'][0]['artist']['name']),
      );
      expect(
        album.images.length,
        albumCoverJson['images'][0]['thumbnails'].length,
      );
      expect(
        album.images[0].url,
        equals(albumCoverJson['images'][0]['thumbnails']['small'] as String),
      );
      expect(album.images[0].width, equals(250));
      expect(album.images[0].height, equals(250));
      expect(
        album.images[1].url,
        equals(albumCoverJson['images'][0]['thumbnails']['large'] as String),
      );
      expect(album.images[1].width, equals(500));
      expect(album.images[1].height, equals(500));
      verify(() => mockNetwork.send(any())).called(2);
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testGetAlbum(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testGetAlbum(evalPlugin));
    });
  });
}
