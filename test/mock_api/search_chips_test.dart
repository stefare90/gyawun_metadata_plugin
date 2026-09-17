import 'package:dart_eval/dart_eval.dart';
import 'package:gyawun_metadata_sdk/eval/eval_plugin.dart';
import 'package:gyawun_metadata_sdk/eval/eval_unboxer.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:test/test.dart';

import '../common/setup.dart';
import '_support/fakes.dart';
import '_support/mocks.dart';

/// Bytecode-side probe: an [ISearch] whose `chips()` returns an arbitrary
/// subset of the closed [SearchCategory] vocabulary. The host-side mirror is
/// [_ProbeSearch]; together they verify the enum survives the bridge for the
/// subset shapes the contract allows (empty, single, full).
const String _probeSource = '''
import 'package:gyawun_metadata_sdk/metadata/interfaces/isearch.dart';
import 'package:gyawun_metadata_sdk/metadata/models/search.dart';

class ProbeSearch extends ISearch {
  final List<SearchCategory> categories;
  ProbeSearch(this.categories);

  @override
  List<SearchCategory> chips() => categories;
}

List<SearchCategory> emptyChips() =>
    ProbeSearch(const <SearchCategory>[]).chips();
List<SearchCategory> albumsOnlyChips() =>
    ProbeSearch(const <SearchCategory>[SearchCategory.albums]).chips();
List<SearchCategory> allChips() => ProbeSearch(const <SearchCategory>[
      SearchCategory.tracks,
      SearchCategory.albums,
      SearchCategory.artists,
      SearchCategory.playlists,
    ]).chips();
''';

class _ProbeSearch extends ISearch {
  _ProbeSearch(this.categories);

  final List<SearchCategory> categories;

  @override
  List<SearchCategory> chips() => categories;
}

void main() {
  group('SearchCategory chips contract', () {
    late HostEnv hostEnv;
    late Runtime probeRuntime;

    setUpAll(() {
      registerFallbackValues();

      final compiler = Compiler();
      compiler.addPlugin(GyawunMetadataSdkPlugin());
      final program = compiler.compile({
        'chips_probe': {'main.dart': _probeSource},
      });
      probeRuntime = Runtime(program.write().buffer.asByteData());
      probeRuntime.addPlugin(GyawunMetadataSdkPlugin());
    });

    setUp(() {
      hostEnv = HostEnv(
        network: MockNetworkService(),
        storage: MockStorage(),
        ui: MockUiService(),
      );
    });

    List<SearchCategory> evalChips(String function) {
      final raw = probeRuntime.executeLib(
        'package:chips_probe/main.dart',
        function,
        [],
      );
      final List unboxed = unboxValue(raw) as List;
      final List<SearchCategory> result = [];
      for (final item in unboxed) {
        result.add(unboxValue(item) as SearchCategory);
      }
      return result;
    }

    void expectEnumListIntact(
      List<SearchCategory> actual,
      List<SearchCategory> expected,
    ) {
      expect(actual, isA<List<SearchCategory>>());
      expect(actual, equals(expected));
      for (var i = 0; i < expected.length; i++) {
        expect(actual[i], same(expected[i]));
      }
    }

    void runChipsSubset(
      String description,
      List<SearchCategory> expected,
      String evalFunction,
    ) {
      test('$description (native)', () {
        expectEnumListIntact(_ProbeSearch(expected).chips(), expected);
      });
      test('$description (eval)', () {
        expectEnumListIntact(evalChips(evalFunction), expected);
      });
    }

    void expectPluginChips(IMetadataPlugin plugin) {
      final chips = plugin.search.chips();
      expectEnumListIntact(chips, const <SearchCategory>[
        SearchCategory.tracks,
        SearchCategory.albums,
        SearchCategory.artists,
      ]);
      for (final category in chips) {
        expect(SearchCategory.values, contains(category));
      }
    }

    test('plugin chips are enum values (native)', () {
      expectPluginChips(getNativePlugin(hostEnv));
    });

    test('plugin chips are enum values (eval)', () {
      expectPluginChips(getEvalPlugin(hostEnv));
    });

    runChipsSubset(
      'empty subset (aggregate-only search)',
      const <SearchCategory>[],
      'emptyChips',
    );

    runChipsSubset(
      'albums-only subset',
      const <SearchCategory>[SearchCategory.albums],
      'albumsOnlyChips',
    );

    runChipsSubset(
      'full vocabulary subset',
      const <SearchCategory>[
        SearchCategory.tracks,
        SearchCategory.albums,
        SearchCategory.artists,
        SearchCategory.playlists,
      ],
      'allChips',
    );
  });
}
