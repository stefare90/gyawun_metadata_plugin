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
      hostEnv = HostEnv(
        network: NetworkService(),
        storage: StorageService(),
        ui: mockUi,
      );
      nativePlugin = getNativePlugin(hostEnv);
      evalPlugin = getEvalPlugin(hostEnv);
    });

    Future<void> testUserID(IMetadataPlugin plugin) async {
      when(
        () => mockUi.showForm(
          title: any(named: 'title'),
          fields: any(named: 'fields'),
        ),
      ).thenAnswer(
        (_) async => {'token': 'cef34476-c3fe-4bb9-9703-026176e3ca1e'},
      );

      await plugin.auth.authenticate();

      final userData = await plugin.user.me();
      expect(userData['user_id'], 'Danfreemanold90');
    }

    group("Native tests", () {
      test('Test getAlbum', () async => await testUserID(nativePlugin));
    });
    group("Eval tests", () {
      test('Test getAlbum', () async => await testUserID(evalPlugin));
    });
  });
}
