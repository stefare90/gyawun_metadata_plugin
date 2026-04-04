// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'icore.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';

/// dart_eval wrapper binding for [ICore]
class $ICore implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$ICore]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/icore.dart',
    'ICore',
  );

  /// Compile-time type declaration of [$ICore]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$ICore]
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
      'checkUpdate': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
                nullable: true,
              ),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'pluginConfig',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
              ),
              false,
            ),
          ],
        ),
      ),

      'support': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
          namedParams: [],
          params: [],
        ),
      ),

      'scrobble': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'details',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
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
  final ICore $value;

  @override
  ICore get $reified => $value;

  /// Wrap a [ICore] in a [$ICore]
  $ICore.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'checkUpdate':
        return __checkUpdate;

      case 'support':
        return __support;

      case 'scrobble':
        return __scrobble;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __checkUpdate = $Function(_checkUpdate);
  static $Value? _checkUpdate(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $ICore;
    final result = self.$value.checkUpdate((args[0]!.$reified as Map).cast());
    return $Future.wrap(
      result.then((e) => e == null ? const $null() : $Map.wrap(e)),
    );
  }

  static const $Function __support = $Function(_support);
  static $Value? _support(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ICore;
    final result = self.$value.support();
    return $String(result);
  }

  static const $Function __scrobble = $Function(_scrobble);
  static $Value? _scrobble(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $ICore;
    final result = self.$value.scrobble((args[0]!.$reified as Map).cast());
    return $Future.wrap(result.then((e) => null));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
