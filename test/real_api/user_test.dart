import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  // Configured with a 3-minute timeout to accommodate the 1-second rate-limiting delays
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

      // Authenticate both plugins once during setup to share authenticated session state
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
      // Logout both sessions cleanly after all tests are finished
      await nativePlugin.auth.logout();
      await evalPlugin.auth.logout();
    });

    // --- Modular Test Helper Methods ---

    Future<void> testUserID(IMetadataPlugin plugin) async {
      final userData = await plugin.user.me();
      expect(userData['user_id'], 'Danfreemanold90');
    }

    Future<void> testAlbumLibrary(IMetadataPlugin plugin) async {
      // "Love Me Do / P.S. I Love You" release-group mbid
      final String testAlbumId = "5db85281-934d-36e5-865c-1922ad82a948";

      // 1. Save album using the official SDK interface
      await plugin.album.save([testAlbumId]);

      // 2. Retrieve saved albums list and assert presence
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
      expect(albumFoundBefore, isTrue); // MUST be present in library

      // 3. Unsave the album using the official SDK interface
      await plugin.album.unsave([testAlbumId]);

      // 4. Retrieve saved albums list again and assert absence (Verifying unsave actually worked)
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
      expect(albumFoundAfter, isFalse); // MUST be gone from library
    }

    Future<void> testArtistLibrary(IMetadataPlugin plugin) async {
      // "The Beatles" artist mbid
      final String testArtistId = "b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d";

      // 1. Save artist using the official SDK interface
      await plugin.artist.save([testArtistId]);

      // 2. Retrieve saved artists list and assert presence
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
      expect(artistFoundBefore, isTrue); // MUST be present in library

      // 3. Unsave the artist using the official SDK interface
      await plugin.artist.unsave([testArtistId]);

      // 4. Retrieve saved artists list again and assert absence (Verifying unsave actually worked)
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
      expect(artistFoundAfter, isFalse); // MUST be gone from library
    }

    Future<void> testTrackLibrary(IMetadataPlugin plugin) async {
      // "Love Me Do" recording mbid
      final String testTrackId = "f87eb4dd-7e3c-4365-a3c8-f144696f5952";

      // 1. Save track (Love) using the official SDK interface
      await plugin.track.save([testTrackId]);

      // 2. Retrieve saved tracks and assert presence
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
      expect(trackFoundBefore, isTrue); // MUST be present in loved tracks list

      // 3. Unsave track (Unlove) using the official SDK interface
      await plugin.track.unsave([testTrackId]);

      // 4. Retrieve saved tracks list again and assert absence (Verifying unsave actually worked)
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
      expect(trackFoundAfter, isFalse); // MUST be gone from loved tracks list
    }

    // TODO: Implement JSPF Playlist save, unsave, and savedPlaylists lifecycle testing
    // once IPlaylist write functions are implemented during IPlaylist class tasks.

    // --- Native Test Suite Group ---
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
    });

    // --- Eval Test Suite Group ---
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
    });
  }, timeout: Timeout(Duration(minutes: 3)));
}
