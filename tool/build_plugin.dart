import 'dart:io';
import 'package:dart_eval/dart_eval.dart';
import 'package:gyawun_metadata_sdk/eval/eval_plugin.dart';
import 'package:path/path.dart' as p;

void main() async {
  final compiler = Compiler();

  // 1. Configure bridge bindings for compilation
  final metadataBridge = GyawunMetadataSdkPlugin();
  compiler.addPlugin(metadataBridge);

  // 2. Loading source files
  print('--- Loading source files ---');
  final pluginSources = _loadSources(p.join(Directory.current.path, 'lib'));

  // 3. Bytecode compilation
  print('--- Compiling Bytecode (.evc) ---');
  try {
    // Define the two packages within the compiler's Virtual File System (VFS)
    final program = compiler.compile({'gyawun_metadata_plugin': pluginSources});

    final bytes = program.write();
    File('plugin.evc').writeAsBytesSync(bytes);

    print('✅ Success! Generated plugin.evc (${bytes.length} bytes)');
  } catch (e) {
    print('❌ Compilation error: $e');
  }
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
      // Calculate the relative path from the root (e.g., metadata/models.dart)
      // and ensure forward slashes are used for cross-platform compatibility
      final relativePath = p
          .relative(file.path, from: rootPath)
          .replaceAll('\\', '/');
      sources[relativePath] = file.readAsStringSync();
    }
  }
  return sources;
}
