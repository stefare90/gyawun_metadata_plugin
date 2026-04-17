import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:gyawun_metadata_sdk/metadata_plugin_sdk.dart';
import '../common/setup.dart';
import '_support/network_service.dart';
import '_support/storage_service.dart';
import '_support/ui_service.dart';

void main() async {
  group("Auth interface test", () {
    late HostEnv hostEnv;
    late IMetadataPlugin nativePlugin;
    late IMetadataPlugin evalPlugin;
    late IUIService mockUi;

    setUpAll(() async {
      mockUi = MockUiService();
      hostEnv = HostEnv(
        network: NetworkService(),
        storage: StorageService(),
        ui: mockUi,
      );
      nativePlugin = getNativePlugin(hostEnv);
      evalPlugin = getEvalPlugin(hostEnv);
    });

    Future<void> testAuthenticate(IMetadataPlugin plugin) async {
      when(
        () => mockUi.showForm(
          title: any(named: 'title'),
          fields: any(named: 'fields'),
        ),
      ).thenAnswer((_) async => {'token': '1234567890'});

      bool isAuth = await plugin.auth.isAuthenticated();

      expect(isAuth, false);

      await plugin.auth.authenticate();

      verify(
        () => mockUi.showForm(
          title: any(named: 'title'),
          fields: any(named: 'fields'),
        ),
      ).called(1);

      isAuth = await plugin.auth.isAuthenticated();

      expect(isAuth, true);

      await plugin.auth.logout();

      isAuth = await plugin.auth.isAuthenticated();

      expect(isAuth, false);
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testAuthenticate(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testAuthenticate(evalPlugin));
    });
  });
}
