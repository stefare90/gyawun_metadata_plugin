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

/// Matches the MusicBrainz artist search request issued by `search.artists()`.
PluginRequest _mbArtistSearchMatcher() => any<PluginRequest>(
  that: predicate<PluginRequest>(
    (req) => req.url.startsWith('https://musicbrainz.org/ws/2/artist?'),
  ),
);

/// Matches the optional Wikidata SPARQL enrichment request.
PluginRequest _sparqlMatcher() => any<PluginRequest>(
  that: predicate<PluginRequest>(
    (req) => req.url.startsWith('https://query.wikidata.org/sparql'),
  ),
);

void main() {
  group('Wikidata artist images (mock resolver)', () {
    late HostEnv hostEnv;
    late INetworkService mockNetwork;
    late IUIService mockUi;
    late IStorageService mockStorage;

    setUpAll(() {
      registerFallbackValues();
    });

    setUp(() {
      mockNetwork = MockNetworkService();
      mockUi = MockUiService();
      mockStorage = MockStorage();
      hostEnv = HostEnv(network: mockNetwork, storage: mockStorage, ui: mockUi);
    });

    tearDown(() {
      reset(mockNetwork);
    });

    void stubMbArtists(String body) {
      when(() => mockNetwork.send(_mbArtistSearchMatcher())).thenAnswer(
        (_) async => PluginResponse(statusCode: 200, body: body),
      );
    }

    void stubSparql(String body) {
      when(() => mockNetwork.send(_sparqlMatcher())).thenAnswer(
        (_) async => PluginResponse(statusCode: 200, body: body),
      );
    }

    /// Runs [body] with a fresh Native and a fresh Eval plugin instance.
    ///
    /// A fresh instance per test matters: the resolver keeps an in-memory
    /// cache, so sharing one would leak cached MBIDs across tests.
    ///
    /// [skip] marks the whole case (native + eval) as deferred future work.
    void runForBoth(
      String description,
      Future<void> Function(IMetadataPlugin) body, {
      String? skip,
    }) {
      test(
        '$description (native)',
        () => body(getNativePlugin(hostEnv)),
        skip: skip,
      );
      test(
        '$description (eval)',
        () => body(getEvalPlugin(hostEnv)),
        skip: skip,
      );
    }

    runForBoth('maps a SPARQL image to the four standard sizes', (
      IMetadataPlugin plugin,
    ) async {
      stubMbArtists(Fixtures.searchArtistsRadiohead);
      stubSparql(Fixtures.sparqlArtistImage);

      final result = await plugin.search.artists(
        'Radiohead',
        limit: 5,
        offset: 0,
      );

      expect(result.items.length, equals(1));
      final artist = result.items.first;
      expect(artist.name, equals('Radiohead'));
      expect(artist.genres, contains('alternative rock'));
      expect(artist.images.length, equals(4));

      final List<int?> widths = <int?>[];
      for (final image in artist.images) {
        widths.add(image.width);
      }
      expect(widths, equals(<int>[56, 250, 500, 1000]));

      for (final image in artist.images) {
        expect(
          image.url,
          startsWith(
            'https://commons.wikimedia.org/wiki/Special:FilePath/',
          ),
        );
        expect(image.url, contains('width='));
        // The fixture is served over http:// and must be upgraded to https.
        expect(image.url.startsWith('http://'), isFalse);
      }
      expect(artist.images.first.url, contains('width=56'));
      expect(artist.images.first.url, contains('Radiohead'));
    });

    runForBoth('caches images so the SPARQL query runs only once', (
      IMetadataPlugin plugin,
    ) async {
      stubMbArtists(Fixtures.searchArtistsRadiohead);
      stubSparql(Fixtures.sparqlArtistImage);

      final first = await plugin.search.artists(
        'Radiohead',
        limit: 5,
        offset: 0,
      );
      final second = await plugin.search.artists(
        'Radiohead',
        limit: 5,
        offset: 0,
      );

      expect(first.items.first.images.length, equals(4));
      expect(second.items.first.images.length, equals(4));

      verify(() => mockNetwork.send(_mbArtistSearchMatcher())).called(2);
      verify(() => mockNetwork.send(_sparqlMatcher())).called(1);
    });

    runForBoth('negative-caches artists without a P18 image', (
      IMetadataPlugin plugin,
    ) async {
      stubMbArtists(Fixtures.searchArtistsNoImage);
      stubSparql(Fixtures.sparqlNoImage);

      final first = await plugin.search.artists(
        'Obscure Artist',
        limit: 5,
        offset: 0,
      );
      final second = await plugin.search.artists(
        'Obscure Artist',
        limit: 5,
        offset: 0,
      );

      expect(first.items.first.images, isEmpty);
      expect(second.items.first.images, isEmpty);
      expect(first.items.first.name, equals('Obscure Artist'));

      // Negative result is cached: the SPARQL endpoint is not hit again.
      verify(() => mockNetwork.send(_sparqlMatcher())).called(1);
      verify(() => mockNetwork.send(_mbArtistSearchMatcher())).called(2);
    });

    // ---------------------------------------------------------------------
    // DEFERRED FUTURE WORK (see PLAN.md / ../.pi/handoff.md).
    //
    // The two cases below describe the required behaviour for transport
    // failures, but they cannot pass until the fix lands at the host/SDK
    // boundary. `dart_eval` 0.8.5 cannot catch an *asynchronous* Future error
    // (only synchronous throws) and its async `try/catch` also corrupts the
    // frame on suspension. The robust fix is to make `send` return a sentinel
    // PluginResponse instead of rethrowing, so `fetchApiOrNull`'s existing
    // non-200 branch degrades gracefully in Native *and* Eval.
    // They are kept (skipped) as the ready-to-enable regression harness.
    // ---------------------------------------------------------------------
    const transportSkipReason =
        'DEFERRED: needs host/SDK non-throwing send (dart_eval 0.8.5 cannot '
        'catch async Future errors). See PLAN.md / handoff.';

    runForBoth(
      'degrades to empty images on a transport error',
      (IMetadataPlugin plugin) async {
        stubMbArtists(Fixtures.searchArtistsRadiohead);
        when(
          () => mockNetwork.send(_sparqlMatcher()),
        ).thenThrow(Exception('SocketException: SPARQL unreachable'));

        final result = await plugin.search.artists(
          'Radiohead',
          limit: 5,
          offset: 0,
        );

        // No exception escapes: the MusicBrainz results survive intact.
        expect(result.items.length, equals(1));
        expect(result.items.first.name, equals('Radiohead'));
        expect(result.items.first.images, isEmpty);
        expect(result.total, equals(1));
      },
      skip: transportSkipReason,
    );

    runForBoth(
      'degrades to empty images on an async transport failure',
      (IMetadataPlugin plugin) async {
        // The real host (`PluginNetworkService.send`) is `async` and rethrows,
        // i.e. it produces a *failed Future*, not a synchronous throw.
        stubMbArtists(Fixtures.searchArtistsRadiohead);
        when(() => mockNetwork.send(_sparqlMatcher())).thenAnswer(
          (_) async => throw Exception('SocketException: SPARQL unreachable'),
        );

        final result = await plugin.search.artists(
          'Radiohead',
          limit: 5,
          offset: 0,
        );

        expect(result.items.length, equals(1));
        expect(result.items.first.name, equals('Radiohead'));
        expect(result.items.first.images, isEmpty);
        expect(result.total, equals(1));
      },
      skip: transportSkipReason,
    );

    runForBoth('degrades to empty images on an HTTP 500', (
      IMetadataPlugin plugin,
    ) async {
      stubMbArtists(Fixtures.searchArtistsRadiohead);
      when(() => mockNetwork.send(_sparqlMatcher())).thenAnswer(
        (_) async =>
            PluginResponse(statusCode: 500, body: 'Internal Server Error'),
      );

      final result = await plugin.search.artists(
        'Radiohead',
        limit: 5,
        offset: 0,
      );

      expect(result.items.length, equals(1));
      expect(result.items.first.name, equals('Radiohead'));
      expect(result.items.first.images, isEmpty);
      expect(result.total, equals(1));
    });
  });
}
