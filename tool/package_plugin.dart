import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

import 'build_plugin.dart' as builder;

const String _evcFileName = 'plugin.evc';
const String _manifestFileName = 'plugin.json';
const String _zipFileName = 'plugin.zip';

/// Compiles the plugin and packages `plugin.evc` + `plugin.json` into
/// `plugin.zip`, ready to be imported by the host app.
///
/// Run from the project root:
/// `dart run tool/package_plugin.dart`
void main() {
  final root = Directory.current.path;

  final manifestFile = File(p.join(root, _manifestFileName));
  if (!manifestFile.existsSync()) {
    stderr.writeln(
      '❌ $_manifestFileName not found. Run this from the project root.',
    );
    exitCode = 1;
    return;
  }

  final evcBytes = builder.compilePlugin();
  File(p.join(root, _evcFileName)).writeAsBytesSync(evcBytes);
  print('✅ Generated $_evcFileName (${evcBytes.length} bytes)');

  final zipBytes = _buildStoredZip(
    <String>[_evcFileName, _manifestFileName],
    <List<int>>[evcBytes, manifestFile.readAsBytesSync()],
  );
  File(p.join(root, _zipFileName)).writeAsBytesSync(zipBytes);
  print('📦 Generated $_zipFileName (${zipBytes.length} bytes)');
  print('👉 Import it in the host app (File Picker) to install the plugin.');
}

/// Builds a ZIP archive (stored / no compression) with the given [names] and
/// [contents]. Implemented with plain byte primitives so it works on every OS
/// without depending on system tools or extra packages.
Uint8List _buildStoredZip(List<String> names, List<List<int>> contents) {
  final output = BytesBuilder();
  final central = BytesBuilder();
  final now = DateTime.now();
  final dosTime = _dosTime(now);
  final dosDate = _dosDate(now);

  for (var i = 0; i < names.length; i++) {
    final nameBytes = utf8.encode(names[i]);
    final data = contents[i];
    final crc = _crc32(data);
    final localOffset = output.length;

    // Local file header + data.
    final local = BytesBuilder();
    local.add(_u32(0x04034b50));
    local.add(_u16(20)); // version needed to extract
    local.add(_u16(0)); // general purpose flags
    local.add(_u16(0)); // compression method: 0 = stored
    local.add(_u16(dosTime));
    local.add(_u16(dosDate));
    local.add(_u32(crc));
    local.add(_u32(data.length)); // compressed size
    local.add(_u32(data.length)); // uncompressed size
    local.add(_u16(nameBytes.length));
    local.add(_u16(0)); // extra field length
    local.add(nameBytes);
    local.add(data);
    output.add(local.takeBytes());

    // Central directory entry.
    final entry = BytesBuilder();
    entry.add(_u32(0x02014b50));
    entry.add(_u16(20)); // version made by
    entry.add(_u16(20)); // version needed to extract
    entry.add(_u16(0)); // flags
    entry.add(_u16(0)); // method
    entry.add(_u16(dosTime));
    entry.add(_u16(dosDate));
    entry.add(_u32(crc));
    entry.add(_u32(data.length)); // compressed size
    entry.add(_u32(data.length)); // uncompressed size
    entry.add(_u16(nameBytes.length));
    entry.add(_u16(0)); // extra field length
    entry.add(_u16(0)); // file comment length
    entry.add(_u16(0)); // disk number start
    entry.add(_u16(0)); // internal attributes
    entry.add(_u32(0)); // external attributes
    entry.add(_u32(localOffset));
    entry.add(nameBytes);
    central.add(entry.takeBytes());
  }

  final centralBytes = central.takeBytes();
  final centralOffset = output.length;
  output.add(centralBytes);

  // End of central directory record.
  final end = BytesBuilder();
  end.add(_u32(0x06054b50));
  end.add(_u16(0)); // disk number
  end.add(_u16(0)); // disk with central directory
  end.add(_u16(names.length)); // entries on this disk
  end.add(_u16(names.length)); // total entries
  end.add(_u32(centralBytes.length));
  end.add(_u32(centralOffset));
  end.add(_u16(0)); // comment length
  output.add(end.takeBytes());

  return output.takeBytes();
}

Uint8List _u16(int value) {
  final bytes = Uint8List(2);
  bytes.buffer.asByteData().setUint16(0, value & 0xffff, Endian.little);
  return bytes;
}

Uint8List _u32(int value) {
  final bytes = Uint8List(4);
  bytes.buffer.asByteData().setUint32(0, value & 0xffffffff, Endian.little);
  return bytes;
}

int _dosTime(DateTime t) =>
    ((t.hour & 0x1f) << 11) |
    ((t.minute & 0x3f) << 5) |
    ((t.second ~/ 2) & 0x1f);

int _dosDate(DateTime t) =>
    (((t.year - 1980) & 0x7f) << 9) | ((t.month & 0xf) << 5) | (t.day & 0x1f);

int _crc32(List<int> data) {
  var crc = 0xffffffff;
  for (final byte in data) {
    crc ^= byte;
    for (var i = 0; i < 8; i++) {
      if ((crc & 1) != 0) {
        crc = (crc >> 1) ^ 0xedb88320;
      } else {
        crc >>= 1;
      }
    }
  }
  return (crc ^ 0xffffffff) & 0xffffffff;
}
