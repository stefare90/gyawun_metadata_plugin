import 'package:gyawun_metadata_plugin/plugin.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = MyPlugin();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.album, isTrue);
    });
  });
}
