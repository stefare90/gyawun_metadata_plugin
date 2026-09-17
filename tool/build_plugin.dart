import 'dart:io';
import 'dart:typed_data';
import 'package:dart_eval/dart_eval.dart';
import 'package:gyawun_metadata_sdk/eval/eval_plugin.dart';
import 'package:path/path.dart' as p;

/// Compiles `lib/` into dart_eval bytecode and writes `plugin.evc`.
///
/// Run from the project root:
/// `dart run tool/build_plugin.dart`
void main() {
  final bytes = compilePlugin();
  File('plugin.evc').writeAsBytesSync(bytes);
  print('✅ Success! Generated plugin.evc (${bytes.length} bytes)');
}

/// Compiles the plugin sources under `lib/` to dart_eval bytecode.
///
/// Uses the project-local `dart_eval` version and registers the SDK bridge
/// (`GyawunMetadataSdkPlugin`), exactly like the test suites expect.
Uint8List compilePlugin() {
  final compiler = Compiler();
  final metadataBridge = GyawunMetadataSdkPlugin();
  compiler.addPlugin(metadataBridge);

  print('--- Loading source files ---');
  final pluginSources = _loadSources(p.join(Directory.current.path, 'lib'));

  print('--- Compiling Bytecode (.evc) ---');
  final program = compiler.compile({'gyawun_metadata_plugin': pluginSources});
  return program.write();
}

/// Helper function to scan a directory and map files for the compiler
Map<String, String> _loadSources(String rootPath) {
  final sources = <String, String>{};
  final dir = Directory(rootPath);

  if (!dir.existsSync()) {
    print('⚠️ Warning: Directory not found: $rootPath');
    return sources;
  }

  for (var file in dir.listSync(recursive: true).whereType<File>()) {
    if (file.path.endsWith('.dart')) {
      // Relative path with forward slashes, so the VFS keys are platform-agnostic.
      final relativePath = p
          .relative(file.path, from: rootPath)
          .replaceAll('\\', '/');
      sources[relativePath] = file.readAsStringSync();
    }
  }
  return sources;
}
