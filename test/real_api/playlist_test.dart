import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  group("Playlist interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;
    late IUIService mockUi;

    const String testPlaylistId = "43a71768-4151-474a-b0e0-a5342a8c7692";

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

    Future<void> testGetPlaylist(IMetadataPlugin plugin) async {
      final data = await plugin.playlist.getPlaylist(testPlaylistId);

      expect(data, isNotEmpty);
      expect(data['playlist'], isNotNull);

      final playlist = data['playlist'] as Map;
      expect(playlist['title'], equals("TestPlaylist"));
      expect(playlist['creator'], equals("Danfreemanold90"));
      expect(playlist['identifier'], contains(testPlaylistId));
    }

    Future<void> testPlaylistTracks(IMetadataPlugin plugin) async {
      final tracks = await plugin.playlist.tracks(
        testPlaylistId,
        offset: 0,
        limit: 5,
      );

      expect(tracks, isA<PaginatedResult<Track>>());
      expect(tracks.offset, equals(0));
      expect(tracks.limit, equals(5));
      expect(tracks.items, isA<List<Track>>());
      expect(tracks.items.length, equals(3));

      final List<String> parsedIds = tracks.items.map((t) => t.id).toList();
      expect(parsedIds, contains("6b77b631-d5b5-4b4f-9ac7-a3844f30d1b2"));
      expect(parsedIds, contains("5a322b5f-9d92-4da2-9de5-b037ec50d0d4"));
      expect(parsedIds, contains("82936e86-694d-4213-b9ba-1b9485ebd50a"));

      final firstTrack = tracks.items.first;
      expect(firstTrack.name, equals("Loro"));
      expect(firstTrack.artists, isNotEmpty);
      expect(firstTrack.artists.first.name, equals("Marracash"));
      expect(firstTrack.album.name, equals("NOI, LORO, GLI ALTRI"));
    }

    Future<void> testPlaylistLifecycle(IMetadataPlugin plugin) async {
      final String tempName = "Gyawun Temp Playlist";
      final String tempDesc = "Temporary playlist generated during E2E tests";

      await _cleanLeftovers(plugin, [tempName]);

      final initialPlaylists = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 20,
      );
      final existsBefore = initialPlaylists.items.any(
        (item) => item.name == tempName,
      );
      expect(existsBefore, isFalse);

      final playlist = await plugin.playlist.createPlaylist(
        "Danfreemanold90",
        tempName,
        description: tempDesc,
        public_: false,
      );

      expect(playlist, isNotNull);
      expect(playlist!.name, equals(tempName));
      expect(playlist.description, equals(tempDesc));
      expect(playlist.id, isNotEmpty);
      expect(playlist.isPublic, isFalse);

      await plugin.playlist.deletePlaylist(playlist.id);

      expect(() => plugin.playlist.getPlaylist(playlist.id), throwsException);
    }

    Future<void> testPlaylistTrackManagement(IMetadataPlugin plugin) async {
      final String tempName = "Gyawun Track Management Test";
      final String tempDesc = "Testing adding and removing tracks dynamically";

      await _cleanLeftovers(plugin, [tempName]);

      final initialPlaylists = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 20,
      );
      final existsBefore = initialPlaylists.items.any(
        (item) => item.name == tempName,
      );
      expect(existsBefore, isFalse);

      final playlist = await plugin.playlist.createPlaylist(
        "Danfreemanold90",
        tempName,
        description: tempDesc,
        public_: false,
      );
      expect(playlist, isNotNull);

      final String testTrackId = "6b77b631-d5b5-4b4f-9ac7-a3844f30d1b2";

      await plugin.playlist.addTracks(playlist!.id, [testTrackId]);

      var tracks = await plugin.playlist.tracks(
        playlist.id,
        offset: 0,
        limit: 5,
      );
      expect(tracks.items.length, equals(1));

      final addedTrack = tracks.items.first;
      expect(addedTrack.id, equals(testTrackId));
      expect(addedTrack.name, equals("Loro"));
      expect(addedTrack.artists, isNotEmpty);
      expect(addedTrack.artists.first.name, equals("Marracash"));
      expect(addedTrack.album.name, equals("NOI, LORO, GLI ALTRI"));

      await plugin.playlist.removeTracks(playlist.id, [testTrackId]);

      tracks = await plugin.playlist.tracks(playlist.id, offset: 0, limit: 5);
      expect(tracks.items, isEmpty);

      await plugin.playlist.deletePlaylist(playlist.id);

      expect(() => plugin.playlist.getPlaylist(playlist.id), throwsException);
    }

    Future<void> testPlaylistUpdateAndSave(IMetadataPlugin plugin) async {
      final String tempName = "Spotube Temp Edit";
      final String updatedName = "Spotube Edited Playlist";

      await _cleanLeftovers(plugin, [
        tempName,
        updatedName,
        "Copy of $updatedName",
      ]);

      final initialPlaylists = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 20,
      );
      final existsBefore = initialPlaylists.items.any(
        (item) => item.name == tempName,
      );
      expect(existsBefore, isFalse);

      final playlist = await plugin.playlist.createPlaylist(
        "Danfreemanold90",
        tempName,
        description: "Initial description",
        public_: false,
      );
      expect(playlist, isNotNull);

      final String updatedDesc = "Edited description";
      await plugin.playlist.updatePlaylist(
        playlist!.id,
        name: updatedName,
        description: updatedDesc,
        public_: true,
      );

      final updatedData = await plugin.playlist.getPlaylist(playlist.id);
      final updatedPlaylist = updatedData['playlist'] as Map;
      expect(updatedPlaylist['title'], equals(updatedName));
      expect(updatedPlaylist['annotation'], equals(updatedDesc));

      await plugin.playlist.save(playlist.id);

      final userPlaylists = await plugin.user.savedPlaylists(
        offset: 0,
        limit: 10,
      );
      bool copyFound = false;
      String? copyMbid;
      for (final item in userPlaylists.items) {
        if (item.name == "Copy of $updatedName") {
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

      expect(() => plugin.playlist.getPlaylist(playlist.id), throwsException);
    }

    group("Native tests", () {
      test('Test getPlaylist', () async => await testGetPlaylist(nativePlugin));
      test(
        'Test tracks pagination',
        () async => await testPlaylistTracks(nativePlugin),
      );
      test(
        'Test playlist lifecycle',
        () async => await testPlaylistLifecycle(nativePlugin),
      );
      test(
        'Test add and remove tracks lifecycle',
        () async => await testPlaylistTrackManagement(nativePlugin),
      );
      test(
        'Test update and save playlist lifecycle',
        () async => await testPlaylistUpdateAndSave(nativePlugin),
      );
    });

    group("Eval tests", () {
      test('Test getPlaylist', () async => await testGetPlaylist(evalPlugin));
      test(
        'Test tracks pagination',
        () async => await testPlaylistTracks(evalPlugin),
      );
      test(
        'Test playlist lifecycle',
        () async => await testPlaylistLifecycle(evalPlugin),
      );
      test(
        'Test add and remove tracks lifecycle',
        () async => await testPlaylistTrackManagement(evalPlugin),
      );
      test(
        'Test update and save playlist lifecycle',
        () async => await testPlaylistUpdateAndSave(evalPlugin),
      );
    });
  }, timeout: Timeout(Duration(minutes: 3)));
}
