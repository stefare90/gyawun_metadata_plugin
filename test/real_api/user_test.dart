import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  group("User interface test", () {
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

      when(
        () => mockUi.showForm(
          title: any(named: 'title'),
          fields: any(named: 'fields'),
        ),
      ).thenAnswer(
        (_) async => {'token': 'cef34476-c3fe-4bb9-9703-026176e3ca1e'},
      );

      await nativePlugin.auth.authenticate();
      await evalPlugin.auth.authenticate();
    });

    tearDownAll(() async {
      await nativePlugin.auth.logout();
      await evalPlugin.auth.logout();
    });

    Future<void> _cleanLeftovers(
      IMetadataPlugin plugin,
      List<String> names,
    ) async {
      final playlists = await plugin.user.savedPlaylists(offset: 0, limit: 100);
      for (final item in playlists.items) {
        if (names.contains(item.name)) {
          await plugin.playlist.deletePlaylist(item.id);
        }
      }
    }

    Future<void> testUserID(IMetadataPlugin plugin) async {
      final userData = await plugin.user.me();
      expect(userData['user_id'], 'Danfreemanold90');
    }

    Future<void> testAlbumLibrary(IMetadataPlugin plugin) async {
      final String testAlbumId = "5db85281-934d-36e5-865c-1922ad82a948";

      await plugin.album.save([testAlbumId]);

      final savedAlbumsBefore = await plugin.user.savedAlbums(
        offset: 0,
        limit: 5,
      );
      expect(savedAlbumsBefore, isA<PaginatedResult<Album>>());
      expect(savedAlbumsBefore.items, isNotEmpty);
      expect(savedAlbumsBefore.items, isA<List<Album>>());

      bool albumFoundBefore = false;
      for (var i = 0; i < savedAlbumsBefore.items.length; i++) {
        if (savedAlbumsBefore.items[i].id == testAlbumId) {
          albumFoundBefore = true;
          break;
        }
      }
      expect(albumFoundBefore, isTrue);

      await plugin.album.unsave([testAlbumId]);

      final savedAlbumsAfter = await plugin.user.savedAlbums(
        offset: 0,
        limit: 5,
      );
      bool albumFoundAfter = false;
      for (var i = 0; i < savedAlbumsAfter.items.length; i++) {
        if (savedAlbumsAfter.items[i].id == testAlbumId) {
          albumFoundAfter = true;
          break;
        }
      }
      expect(albumFoundAfter, isFalse);
    }

    Future<void> testArtistLibrary(IMetadataPlugin plugin) async {
      final String testArtistId = "b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d";

      await plugin.artist.save([testArtistId]);

      final savedArtistsBefore = await plugin.user.savedArtists(
        offset: 0,
        limit: 5,
      );
      expect(savedArtistsBefore, isA<PaginatedResult<Artist>>());
      expect(savedArtistsBefore.items, isNotEmpty);
      expect(savedArtistsBefore.items, isA<List<Artist>>());

      bool artistFoundBefore = false;
      for (var i = 0; i < savedArtistsBefore.items.length; i++) {
        if (savedArtistsBefore.items[i].id == testArtistId) {
          artistFoundBefore = true;
          break;
        }
      }
      expect(artistFoundBefore, isTrue);

      await plugin.artist.unsave([testArtistId]);

      final savedArtistsAfter = await plugin.user.savedArtists(
        offset: 0,
        limit: 5,
      );
      bool artistFoundAfter = false;
      for (var i = 0; i < savedArtistsAfter.items.length; i++) {
        if (savedArtistsAfter.items[i].id == testArtistId) {
          artistFoundAfter = true;
          break;
        }
      }
      expect(artistFoundAfter, isFalse);
    }

    Future<void> testTrackLibrary(IMetadataPlugin plugin) async {
      final String testTrackId = "f87eb4dd-7e3c-4365-a3c8-f144696f5952";

      await plugin.track.save([testTrackId]);

      final savedTracksBefore = await plugin.user.savedTracks(
        offset: 0,
        limit: 5,
      );
      expect(savedTracksBefore, isA<PaginatedResult<Track>>());
      expect(savedTracksBefore.items, isNotEmpty);
      expect(savedTracksBefore.items, isA<List<Track>>());

      bool trackFoundBefore = false;
      for (var i = 0; i < savedTracksBefore.items.length; i++) {
        if (savedTracksBefore.items[i].id == testTrackId) {
          trackFoundBefore = true;
          break;
        }
      }
      expect(trackFoundBefore, isTrue);

      await plugin.track.unsave([testTrackId]);

      final savedTracksAfter = await plugin.user.savedTracks(
        offset: 0,
        limit: 5,
      );
      bool trackFoundAfter = false;
      for (var i = 0; i < savedTracksAfter.items.length; i++) {
        if (savedTracksAfter.items[i].id == testTrackId) {
          trackFoundAfter = true;
          break;
        }
      }
      expect(trackFoundAfter, isFalse);
    }

    Future<void> testPlaylistLibrary(IMetadataPlugin plugin) async {
      final String tempName = "Spotube User Playlist Test";
      final String copyName = "Copy of Spotube User Playlist Test";

      await _cleanLeftovers(plugin, [tempName, copyName]);

      final savedBefore = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 100,
      );
      expect(savedBefore.items.any((p) => p.name == tempName), isFalse);

      final playlist = await plugin.playlist.createPlaylist(
        "Danfreemanold90",
        tempName,
        description: "User test playlist",
        public_: false,
      );
      expect(playlist, isNotNull);
      expect(playlist!.id, isNotEmpty);

      final savedAfterCreate = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 100,
      );
      expect(savedAfterCreate.items.any((p) => p.name == tempName), isTrue);

      await plugin.playlist.save(playlist.id);

      final savedAfterCopy = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 100,
      );
      bool copyFound = false;
      String? copyMbid;
      for (final item in savedAfterCopy.items) {
        if (item.name == copyName) {
          copyFound = true;
          copyMbid = item.id;
          break;
        }
      }
      expect(copyFound, isTrue);

      if (copyMbid != null) {
        await plugin.playlist.unsave(copyMbid);
      }

      await plugin.playlist.unsave(playlist.id);

      final savedAfterCleanup = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 100,
      );
      expect(
        savedAfterCleanup.items.any(
          (p) => p.name == tempName || p.name == copyName,
        ),
        isFalse,
      );

      expect(() => plugin.playlist.getPlaylist(playlist.id), throwsException);
    }

    group("Native tests", () {
      test(
        'Test user_id retrieval (me)',
        () async => await testUserID(nativePlugin),
      );
      test(
        'Test album library lifecycle (save -> savedAlbums -> unsave)',
        () async => await testAlbumLibrary(nativePlugin),
      );
      test(
        'Test artist library lifecycle (save -> savedArtists -> unsave)',
        () async => await testArtistLibrary(nativePlugin),
      );
      test(
        'Test track library lifecycle (save -> savedTracks -> unsave)',
        () async => await testTrackLibrary(nativePlugin),
      );
      test(
        'Test playlist library lifecycle (create -> savedPlaylists -> save -> unsave)',
        () async => await testPlaylistLibrary(nativePlugin),
      );
    });

    group("Eval tests", () {
      test(
        'Test user_id retrieval (me)',
        () async => await testUserID(evalPlugin),
      );
      test(
        'Test album library lifecycle (save -> savedAlbums -> unsave)',
        () async => await testAlbumLibrary(evalPlugin),
      );
      test(
        'Test artist library lifecycle (save -> savedArtists -> unsave)',
        () async => await testArtistLibrary(evalPlugin),
      );
      test(
        'Test track library lifecycle (save -> savedTracks -> unsave)',
        () async => await testTrackLibrary(evalPlugin),
      );
      test(
        'Test playlist library lifecycle (create -> savedPlaylists -> save -> unsave)',
        () async => await testPlaylistLibrary(evalPlugin),
      );
    });
  }, timeout: Timeout(Duration(minutes: 3)));
}
