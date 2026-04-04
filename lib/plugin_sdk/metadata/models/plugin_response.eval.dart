// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'plugin_response.dart';
import 'package:dart_eval/stdlib/core.dart';

/// dart_eval wrapper binding for [PluginResponse]
class $PluginResponse implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_response.dart',
      'PluginResponse.',
      $PluginResponse.$new,
    );
  }

  /// Compile-time type specification of [$PluginResponse]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_response.dart',
    'PluginResponse',
  );

  /// Compile-time type declaration of [$PluginResponse]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$PluginResponse]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'statusCode',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'body',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
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
      'statusCode': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'body': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [PluginResponse.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $PluginResponse.wrap(
      PluginResponse(statusCode: args[0]!.$value, body: args[1]!.$value),
    );
  }

  final $Instance _superclass;

  @override
  final PluginResponse $value;

  @override
  PluginResponse get $reified => $value;

  /// Wrap a [PluginResponse] in a [$PluginResponse]
  $PluginResponse.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'statusCode':
        final _statusCode = $value.statusCode;
        return $int(_statusCode);

      case 'body':
        final _body = $value.body;
        return $String(_body);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
