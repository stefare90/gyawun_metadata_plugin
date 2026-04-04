// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'inetwork_service.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_response.eval.dart';

/// dart_eval wrapper binding for [INetworkService]
class $INetworkService implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$INetworkService]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/inetwork_service.dart',
    'INetworkService',
  );

  /// Compile-time type declaration of [$INetworkService]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$INetworkService]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type, isAbstract: true),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [],
          params: [],
        ),
        isFactory: false,
      ),
    },

    methods: {
      'send': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_response.dart',
                    'PluginResponse',
                  ),
                  [],
                ),
              ),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'request',
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/plugin_request.dart',
                    'PluginRequest',
                  ),
                  [],
                ),
              ),
              false,
            ),
          ],
        ),
      ),
    },
    getters: {},
    setters: {},
    fields: {},
    wrap: true,
    bridge: false,
  );

  final $Instance _superclass;

  @override
  final INetworkService $value;

  @override
  INetworkService get $reified => $value;

  /// Wrap a [INetworkService] in a [$INetworkService]
  $INetworkService.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'send':
        return __send;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __send = $Function(_send);
  static $Value? _send(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $INetworkService;
    final result = self.$value.send(args[0]!.$value);
    return $Future.wrap(result.then((e) => $PluginResponse.wrap(e)));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
