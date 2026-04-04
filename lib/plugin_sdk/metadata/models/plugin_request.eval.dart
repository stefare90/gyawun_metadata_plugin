// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'plugin_request.dart';
import 'package:dart_eval/stdlib/core.dart';

/// dart_eval wrapper binding for [PluginRequest]
class $PluginRequest implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_request.dart',
      'PluginRequest.',
      $PluginRequest.$new,
    );
  }

  /// Compile-time type specification of [$PluginRequest]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_request.dart',
    'PluginRequest',
  );

  /// Compile-time type declaration of [$PluginRequest]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$PluginRequest]
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
              'method',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              true,
            ),

            BridgeParameter(
              'headers',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
              ),
              true,
            ),

            BridgeParameter(
              'body',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string, []),
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

      'method': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'headers': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.map, [
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
          ]),
        ),
        isStatic: false,
      ),

      'body': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.string, []),
          nullable: true,
        ),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [PluginRequest.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $PluginRequest.wrap(
      PluginRequest(
        url: args[0]!.$value,
        method: args[1]?.$value ?? 'GET',
        headers: (args[2]?.$reified ?? const {} as Map?)?.cast(),
        body: args[3]?.$value,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final PluginRequest $value;

  @override
  PluginRequest get $reified => $value;

  /// Wrap a [PluginRequest] in a [$PluginRequest]
  $PluginRequest.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'url':
        final _url = $value.url;
        return $String(_url);

      case 'method':
        final _method = $value.method;
        return $String(_method);

      case 'headers':
        final _headers = $value.headers;
        return $Map.wrap(_headers);

      case 'body':
        final _body = $value.body;
        return _body == null ? const $null() : $String(_body);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
