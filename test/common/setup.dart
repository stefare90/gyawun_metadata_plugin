import 'dart:io';

import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:gyawun_metadata_sdk/eval/eval_plugin.dart';
import 'package:gyawun_metadata_sdk/eval/host_env.eval.dart';
import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/imetadata_plugin.dart';
import 'package:test/test.dart';

IMetadataPlugin getNativePlugin(HostEnv hostEnv) {
  return MusicbrainzPlugin(hostEnv: hostEnv);
}

IMetadataPlugin getEvalPlugin(HostEnv hostEnv) {
  final file = File('plugin.evc');
  expect(
    file.existsSync(),
    isTrue,
    reason: 'Bytecode file should exist at plugin.evc',
  );
  final bytes = file.readAsBytesSync();

  // 2. INITIALIZE RUNTIME
  final runtime = Runtime(bytes.buffer.asByteData());

  // 3. ADD PLUGIN TO RUNTIME
  final sdkBridge = GyawunMetadataSdkPlugin();
  runtime.addPlugin(sdkBridge);

  // 5. PLUGIN INSTANTIATION
  final result = runtime.executeLib(
    'package:gyawun_metadata_plugin/main.dart',
    'getPlugin',
    [$HostEnv.wrap(hostEnv)],
  );

  return result as IMetadataPlugin;
}
