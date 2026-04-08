import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';

void main() async {
  group("Album interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;

    setUpAll(() async {
      hostEnv = HostEnv(network: NetworkService());
      nativePlugin = getNativePlugin(hostEnv);
      evalPlugin = getEvalPlugin(hostEnv);
    });

    Future<void> testGetAlbum(IMetadataPlugin plugin) async {
      final album = await plugin.album.getAlbum(
        '2c053984-4645-4699-9474-d2c35c227028',
      );

      expect(album, isA<Album>());
      expect(album.id, equals("2c053984-4645-4699-9474-d2c35c227028"));
      expect(album.name, equals("Help!"));
      expect(album.artists.length, 1);
      expect(album.artists.first.name, equals("The Beatles"));
      expect(
        album.artists.first.id,
        equals("b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d"),
      );
      expect(
        album.artists.first.externalUri,
        equals(
          "https://musicbrainz.org/ws/2/artist/b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d",
        ),
      );
    }

    Future<void> testReleases(IMetadataPlugin plugin) async {
      dynamic result = await plugin.album.releases();

      expect(result, isA<PaginatedResult<Album>>());
      expect(result.items.length, equals(1));
      expect(result.items[0].id, equals('123'));
      expect(result.items[0].name, equals('Test Album'));
      expect(result.offset, equals(0));
      expect(result.limit, equals(20));

      result = await plugin.album.releases(offset: 10, limit: 5);

      expect(result.offset, equals(10));
      expect(result.limit, equals(5));
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testGetAlbum(nativePlugin));
      test('Test releases', () async => await testReleases(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testGetAlbum(evalPlugin));
      test('Test releases', () async => await testReleases(evalPlugin));
    });
  });
}
