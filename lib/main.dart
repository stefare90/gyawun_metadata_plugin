import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/imetadata_plugin.dart';

IMetadataPlugin getPlugin(HostEnv hostEnv) {
  return MusicbrainzPlugin(hostEnv: hostEnv);
}
