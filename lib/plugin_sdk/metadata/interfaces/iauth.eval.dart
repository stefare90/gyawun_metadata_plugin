// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'iauth.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';

/// dart_eval wrapper binding for [IAuth]
class $IAuth implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$IAuth]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iauth.dart',
    'IAuth',
  );

  /// Compile-time type declaration of [$IAuth]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$IAuth]
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
      'authenticate': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'id',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'logout': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'isAuthenticated': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
            ]),
          ),
          namedParams: [],
          params: [],
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
  final IAuth $value;

  @override
  IAuth get $reified => $value;

  /// Wrap a [IAuth] in a [$IAuth]
  $IAuth.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'authenticate':
        return __authenticate;

      case 'logout':
        return __logout;

      case 'isAuthenticated':
        return __isAuthenticated;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __authenticate = $Function(_authenticate);
  static $Value? _authenticate(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IAuth;
    final result = self.$value.authenticate(args[0]!.$value);
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __logout = $Function(_logout);
  static $Value? _logout(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IAuth;
    final result = self.$value.logout();
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __isAuthenticated = $Function(_isAuthenticated);
  static $Value? _isAuthenticated(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IAuth;
    final result = self.$value.isAuthenticated();
    return $Future.wrap(result.then((e) => $bool(e)));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
