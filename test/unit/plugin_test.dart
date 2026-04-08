import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:test/test.dart';

import '../_support/mock_network_service.dart';

void main() {
  group('Plugin Unit Test - Album interface test', () {
    HostEnv hostEnv = HostEnv(network: MockNetworkServiceRealCall());
    final plugin = MusicbrainzPlugin(hostEnv: hostEnv);

    setUp(() {});

    test('Test get Album', () async {
      final album = await plugin.album.getAlbum(
        "2c053984-4645-4699-9474-d2c35c227028",
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
    });
  });
}
