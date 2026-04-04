// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'image.dart';
import 'package:dart_eval/stdlib/core.dart';

/// dart_eval wrapper binding for [Image]
class $Image implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.dart',
      'Image.',
      $Image.$new,
    );
  }

  /// Compile-time type specification of [$Image]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.dart',
    'Image',
  );

  /// Compile-time type declaration of [$Image]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$Image]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'url',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'width',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.int, []),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'height',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.int, []),
                nullable: true,
              ),
              true,
            ),
          ],
          params: [],
        ),
        isFactory: false,
      ),
    },

    methods: {},
    getters: {},
    setters: {},
    fields: {
      'url': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'width': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, []), nullable: true),
        isStatic: false,
      ),

      'height': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, []), nullable: true),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [Image.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $Image.wrap(
      Image(
        url: args[0]!.$value,
        width: args[1]?.$value,
        height: args[2]?.$value,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final Image $value;

  @override
  Image get $reified => $value;

  /// Wrap a [Image] in a [$Image]
  $Image.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'url':
        final _url = $value.url;
        return $String(_url);

      case 'width':
        final _width = $value.width;
        return _width == null ? const $null() : $int(_width);

      case 'height':
        final _height = $value.height;
        return _height == null ? const $null() : $int(_height);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
