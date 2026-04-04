// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'pagination.dart';
import 'package:dart_eval/stdlib/core.dart';

/// dart_eval wrapper binding for [PaginatedResult]
class $PaginatedResult implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.dart',
      'PaginatedResult.',
      $PaginatedResult.$new,
    );
  }

  /// Compile-time type specification of [$PaginatedResult]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.dart',
    'PaginatedResult',
  );

  /// Compile-time type declaration of [$PaginatedResult]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$PaginatedResult]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type, generics: {'T': BridgeGenericParam()}),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'items',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(BridgeTypeRef.ref('T')),
                ]),
              ),
              false,
            ),

            BridgeParameter(
              'total',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'offset',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'limit',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
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
      'items': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(BridgeTypeRef.ref('T')),
          ]),
        ),
        isStatic: false,
      ),

      'total': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'offset': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'limit': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [PaginatedResult.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $PaginatedResult.wrap(
      PaginatedResult(
        items: (args[0]!.$reified as List).cast(),
        total: args[1]!.$value,
        offset: args[2]!.$value,
        limit: args[3]!.$value,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final PaginatedResult $value;

  @override
  PaginatedResult get $reified => $value;

  /// Wrap a [PaginatedResult] in a [$PaginatedResult]
  $PaginatedResult.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'items':
        final _items = $value.items;
        return $List.view(_items, (e) => runtime.wrapAlways(e));

      case 'total':
        final _total = $value.total;
        return $int(_total);

      case 'offset':
        final _offset = $value.offset;
        return $int(_offset);

      case 'limit':
        final _limit = $value.limit;
        return $int(_limit);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
