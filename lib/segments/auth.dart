import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iauth.dart';
import 'package:gyawun_metadata_sdk/metadata/models/form_input_field.dart';

class MusicbrainzAuth extends IAuth {
  final HostTools _host;
  String token = "";

  MusicbrainzAuth(this._host);

  @override
  Future<void> authenticate() async {
    final Map result = await _host.env.ui.showForm(
      title: "MusicBrainz authentication",
      fields: [FormInputField(id: "token", label: "token")],
    );
    final newToken = result["token"] as String?;
    if (newToken != null) {
      token = newToken;
      await _host.env.storage.set("token", newToken);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    if (token == "") {
      final String? savedToken = await _host.env.storage.get("token");
      if (savedToken != null) {
        token = savedToken;
      }
    }
    return token != "";
  }

  @override
  Future<void> logout() async {
    token = "";
    await _host.env.storage.delete("token");
  }
}
