import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iauth.dart';
import 'package:gyawun_metadata_sdk/metadata/models/form_input_field.dart';

class MusicbrainzAuth extends IAuth {
  final String mbUrl;
  final String mbUriBase;
  final HostEnv hostEnv;
  String token = "";

  MusicbrainzAuth(this.mbUrl, this.mbUriBase, this.hostEnv);

  @override
  Future<void> authenticate() async {
    final Map result = await hostEnv.ui.showForm(
      title: "MusicBrainz authentication",
      fields: [FormInputField(id: "token", label: "token")],
    );
    final newToken = result["token"] as String?;
    if (newToken != null) {
      token = newToken;
      await hostEnv.storage.set("token", newToken);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    if (token == "") {
      final String? savedToken = await hostEnv.storage.get("token");
      if (savedToken != null) {
        token = savedToken;
      }
    }
    return token != "";
  }

  @override
  Future<void> logout() async {
    token = "";
    await hostEnv.storage.delete("token");
  }
}
