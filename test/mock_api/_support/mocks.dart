import 'package:gyawun_metadata_sdk/metadata/interfaces/inetwork_service.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/istorage_service.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iui_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkService extends Mock implements INetworkService {}

class MockUiService extends Mock implements IUIService {}

class MockStorage extends Mock implements IStorageService {}
