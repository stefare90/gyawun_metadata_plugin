import 'interfaces.dart';

abstract class MetadataHost {
  MetadataHost._();

  static late final INetworkService network;

  static void setup(INetworkService service) {
    MetadataHost.network = service;
  }
}
