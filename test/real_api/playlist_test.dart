import 'package:dart_eval/dart_eval_bridge.dart';
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

    /// TEST AGGIORNATO: Ora riceve direttamente l'oggetto Playlist? tipizzato!
    Future<void> testGetPlaylist(IMetadataPlugin plugin) async {
      final playlist = await plugin.playlist.getPlaylist(testPlaylistId);

      expect(playlist, isNotNull);
      expect(playlist, isA<Playlist>());
      expect(playlist.name, equals("TestPlaylist"));
      expect(playlist.owner.name, equals("Danfreemanold90"));
      expect(playlist.externalUri, contains(testPlaylistId));
      expect(playlist.images, isNotNull);
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
      expect(firstTrack.artists.first.id, isNotEmpty);
      expect(
        firstTrack.artists.first.externalUri,
        contains("musicbrainz.org/artist/"),
      );

      expect(firstTrack.album.name, equals("NOI, LORO, GLI ALTRI"));
      expect(firstTrack.album.id, isNotEmpty);
      expect(firstTrack.album.images, isNotEmpty);
      expect(
        firstTrack.album.images.first.url,
        contains("coverartarchive.org/release/"),
      );
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
      expect(addedTrack.artists.first.id, isNotEmpty);

      expect(addedTrack.album.name, equals("NOI, LORO, GLI ALTRI"));
      expect(addedTrack.album.images, isNotEmpty);

      await plugin.playlist.removeTracks(playlist.id, [testTrackId]);

      tracks = await plugin.playlist.tracks(playlist.id, offset: 0, limit: 5);
      expect(tracks.items, isEmpty);

      await plugin.playlist.deletePlaylist(playlist.id);

      expect(() => plugin.playlist.getPlaylist(playlist.id), throwsException);
    }

    /// TEST AGGIORNATO: Verifica l'aggiornamento leggendo direttamente le proprietà del modello
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

      final updatedPlaylist = await plugin.playlist.getPlaylist(playlist.id);
      expect(updatedPlaylist, isNotNull);
      expect(updatedPlaylist!.name, equals(updatedName));
      expect(updatedPlaylist.description, equals(updatedDesc));

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

    /// TEST AGGIORNATO: Verifica Radio Artista con il modello Playlist
    Future<void> testArtistRadioLifecycle(IMetadataPlugin plugin) async {
      const String artistRadioId = "radio:artist:The Beatles";

      final playlist = await plugin.playlist.getPlaylist(artistRadioId);
      expect(playlist, isNotNull);
      expect(playlist!.name, equals("The Beatles Radio"));
      expect(playlist.owner.name, equals("listenbrainz"));
      expect(playlist.externalUri, contains(artistRadioId));

      try {
        final tracksPage1 = await plugin.playlist.tracks(
          artistRadioId,
          offset: 0,
          limit: 2,
        );
        expect(tracksPage1, isA<PaginatedResult<Track>>());
        expect(tracksPage1.offset, equals(0));
        expect(tracksPage1.limit, equals(2));
        expect(tracksPage1.items, isNotEmpty);

        final tracksPage2 = await plugin.playlist.tracks(
          artistRadioId,
          offset: 1,
          limit: 2,
        );
        expect(tracksPage2, isA<PaginatedResult<Track>>());
        expect(tracksPage2.offset, equals(1));
        expect(tracksPage2.limit, equals(2));
        expect(tracksPage2.items, isNotEmpty);

        if (tracksPage1.items.length > 1 && tracksPage2.items.isNotEmpty) {
          final trackFromPage1 = tracksPage1.items[1];
          final trackFromPage2 = tracksPage2.items[0];
          expect(trackFromPage2.id, equals(trackFromPage1.id));
        }
      } catch (e) {
        final String errorMsg = e is $Value
            ? e.$value.toString()
            : e.toString();

        if (errorMsg.contains("LB Radio currently disabled")) {
          print(
            "⚠️ Warning: Skipping testArtistRadioLifecycle tracks fetch because ListenBrainz Radio is currently disabled due to high server load.",
          );
        } else {
          rethrow;
        }
      }
    }

    /// TEST AGGIORNATO: Verifica Radio Mood con il modello Playlist
    Future<void> testMoodRadioLifecycle(IMetadataPlugin plugin) async {
      const String moodRadioId = "radio:tag:chill";

      final playlist = await plugin.playlist.getPlaylist(moodRadioId);
      expect(playlist, isNotNull);
      expect(playlist!.name, equals("Chill Mood"));
      expect(playlist.owner.name, equals("listenbrainz"));
      expect(playlist.externalUri, contains(moodRadioId));

      try {
        final tracksPage1 = await plugin.playlist.tracks(
          moodRadioId,
          offset: 0,
          limit: 2,
        );
        expect(tracksPage1, isA<PaginatedResult<Track>>());
        expect(tracksPage1.offset, equals(0));
        expect(tracksPage1.limit, equals(2));
        expect(tracksPage1.items, isNotEmpty);

        final tracksPage2 = await plugin.playlist.tracks(
          moodRadioId,
          offset: 1,
          limit: 2,
        );
        expect(tracksPage2, isA<PaginatedResult<Track>>());
        expect(tracksPage2.offset, equals(1));
        expect(tracksPage2.limit, equals(2));
        expect(tracksPage2.items, isNotEmpty);

        if (tracksPage1.items.length > 1 && tracksPage2.items.isNotEmpty) {
          final trackFromPage1 = tracksPage1.items[1];
          final trackFromPage2 = tracksPage2.items[0];
          expect(trackFromPage2.id, equals(trackFromPage1.id));
        }
      } catch (e) {
        final String errorMsg = e is $Value
            ? e.$value.toString()
            : e.toString();

        if (errorMsg.contains("LB Radio currently disabled")) {
          print(
            "⚠️ Warning: Skipping testMoodRadioLifecycle tracks fetch because ListenBrainz Radio is currently disabled due to high server load.",
          );
        } else {
          rethrow;
        }
      }
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
      test(
        'Test artist radio lifecycle',
        () async => await testArtistRadioLifecycle(nativePlugin),
      );
      test(
        'Test mood radio lifecycle',
        () async => await testMoodRadioLifecycle(nativePlugin),
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
      test(
        'Test artist radio lifecycle',
        () async => await testArtistRadioLifecycle(evalPlugin),
      );
      test(
        'Test mood radio lifecycle',
        () async => await testMoodRadioLifecycle(evalPlugin),
      );
    });
  }, timeout: Timeout(Duration(minutes: 3)));
}
