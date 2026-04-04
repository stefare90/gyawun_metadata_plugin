// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'ibrowse.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.eval.dart';

/// dart_eval wrapper binding for [IBrowse]
class $IBrowse implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$IBrowse]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/ibrowse.dart',
    'IBrowse',
  );

  /// Compile-time type declaration of [$IBrowse]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$IBrowse]
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
      'sections': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.dart',
                    'PaginatedResult',
                  ),
                  [
                    BridgeTypeAnnotation(
                      BridgeTypeRef(
                        BridgeTypeSpec(
                          'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/section.dart',
                          'Section',
                        ),
                        [],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          namedParams: [
            BridgeParameter(
              'offset',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              true,
            ),

            BridgeParameter(
              'limit',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              true,
            ),
          ],
          params: [],
        ),
      ),

      'sectionItems': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.dart',
                    'PaginatedResult',
                  ),
                  [BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic))],
                ),
              ),
            ]),
          ),
          namedParams: [
            BridgeParameter(
              'offset',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              true,
            ),

            BridgeParameter(
              'limit',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              true,
            ),
          ],
          params: [
            BridgeParameter(
              'id',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
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
  final IBrowse $value;

  @override
  IBrowse get $reified => $value;

  /// Wrap a [IBrowse] in a [$IBrowse]
  $IBrowse.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'sections':
        return __sections;

      case 'sectionItems':
        return __sectionItems;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __sections = $Function(_sections);
  static $Value? _sections(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IBrowse;
    final result = self.$value.sections(
      offset: args[0]?.$value ?? 0,
      limit: args[1]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __sectionItems = $Function(_sectionItems);
  static $Value? _sectionItems(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IBrowse;
    final result = self.$value.sectionItems(
      args[0]!.$value,
      offset: args[1]?.$value ?? 0,
      limit: args[2]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
