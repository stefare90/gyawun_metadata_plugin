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
      expect(album.images.length, 2);
      expect(
        album.images[0].url,
        equals(
          "http://coverartarchive.org/release/2c053984-4645-4699-9474-d2c35c227028/6119756270-250.jpg",
        ),
      );
      expect(album.images[0].width, equals(250));
      expect(album.images[0].height, equals(250));
      expect(
        album.images[1].url,
        equals(
          "http://coverartarchive.org/release/2c053984-4645-4699-9474-d2c35c227028/6119756270-500.jpg",
        ),
      );
      expect(album.images[1].width, equals(500));
      expect(album.images[1].height, equals(500));
      expect(album.releaseDate, equals("1965-08-06"));
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testGetAlbum(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testGetAlbum(evalPlugin));
    });
  });
}
