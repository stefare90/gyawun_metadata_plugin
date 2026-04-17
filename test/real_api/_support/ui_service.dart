import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:gyawun_metadata_sdk/metadata/models/form_input_field.dart';
import 'package:mocktail/mocktail.dart';

class MockUiService extends Mock implements IUIService {}

class FakeInputField extends Fake implements FormInputField {}
