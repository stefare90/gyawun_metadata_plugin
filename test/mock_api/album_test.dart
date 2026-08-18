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

    tearDown(() {
      reset(mockNetwork);
    });

    // Test 1: getAlbum passando direttamente un Release ID ("123")
    Future<void> testGetAlbumWithReleaseId(IMetadataPlugin plugin) async {
      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/release/123?inc=artist-credits%2Brecordings%2Brelease-groups&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async => PluginResponse(statusCode: 200, body: Fixtures.albumHelp),
      );

      final album = await plugin.album.getAlbum('123');
      final albumJson = jsonDecode(Fixtures.albumHelp);

      expect(album.name, equals(albumJson['title']));
      // Verifica che l'ID sia stato normalizzato a "rg:..." grazie al blocco release-group
      expect(album.id, equals("rg:rg-help-123"));
      expect(album.albumType, equals(AlbumType.album));
      expect(album.releaseDate, equals(albumJson['date']));
      expect(album.totalTracks, equals(albumJson['media'][0]['track-count']));
      expect(album.artists.length, equals(1));
      expect(
        album.artists[0].name,
        equals(albumJson['artist-credit'][0]['artist']['name']),
      );
      verify(() => mockNetwork.send(any())).called(1);
    }

    Future<void> testGetAlbumWithReleaseGroupId(IMetadataPlugin plugin) async {
      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/release?release-group=rg-help-123&limit=1&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async =>
            PluginResponse(statusCode: 200, body: Fixtures.releaseGroupLookup),
      );

      // 2. Chiamata dettagli release
      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/release/123?inc=artist-credits%2Brecordings%2Brelease-groups&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async => PluginResponse(statusCode: 200, body: Fixtures.albumHelp),
      );

      final album = await plugin.album.getAlbum('rg:rg-help-123');

      expect(album.name, equals("Help!"));
      expect(album.id, equals("rg:rg-help-123"));
      verify(() => mockNetwork.send(any())).called(2);
    }

    Future<void> testTracksWithReleaseGroupId(IMetadataPlugin plugin) async {
      // 1. Risoluzione release-group -> release (chiamata una sola volta!)
      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/release?release-group=rg-help-123&limit=1&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async =>
            PluginResponse(statusCode: 200, body: Fixtures.releaseGroupLookup),
      );

      when(
        () => mockNetwork.send(
          any(
            that: predicate<PluginRequest>(
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/release/123?inc=artist-credits%2Brecordings%2Brelease-groups&fmt=json',
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
              (req) =>
                  req.url ==
                  'https://musicbrainz.org/ws/2/recording?release=123&limit=20&offset=0&inc=artist-credits&fmt=json',
            ),
          ),
        ),
      ).thenAnswer(
        (_) async =>
            PluginResponse(statusCode: 200, body: Fixtures.recordingsHelp),
      );

      final result = await plugin.album.tracks('rg:rg-help-123');

      expect(result.items.length, equals(1));
      expect(result.items[0].name, equals("Help!"));
      expect(result.items[0].album.id, equals("rg:rg-help-123"));
      verify(() => mockNetwork.send(any())).called(3);
    }

    group("Native tests", () {
      test(
        'Test getAlbum with Release ID',
        () async => await testGetAlbumWithReleaseId(nativePlugin),
      );
      test(
        'Test getAlbum with Release Group ID',
        () async => await testGetAlbumWithReleaseGroupId(nativePlugin),
      );
      test(
        'Test tracks with Release Group ID',
        () async => await testTracksWithReleaseGroupId(nativePlugin),
      );
    });

    group("Eval tests", () {
      test(
        'Test getAlbum with Release ID',
        () async => await testGetAlbumWithReleaseId(evalPlugin),
      );
      test(
        'Test getAlbum with Release Group ID',
        () async => await testGetAlbumWithReleaseGroupId(evalPlugin),
      );
      test(
        'Test tracks with Release Group ID',
        () async => await testTracksWithReleaseGroupId(evalPlugin),
      );
    });
  });
}
