import 'package:gyawun_metadata_sdk/metadata/models/form_input_field.dart';
import 'package:gyawun_metadata_sdk/metadata/models/plugin_request.dart';
import 'package:mocktail/mocktail.dart';

class FakePluginRequest extends Fake implements PluginRequest {}

void registerFallbackValues() {
  registerFallbackValue(FakePluginRequest());
}

class FakeInputField extends Fake implements FormInputField {}
