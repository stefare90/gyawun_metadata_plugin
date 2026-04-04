// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'browse_section.dart';
import 'package:dart_eval/stdlib/core.dart';

/// dart_eval wrapper binding for [BrowseSection]
class $BrowseSection implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/browse_section.dart',
      'BrowseSection.',
      $BrowseSection.$new,
    );
  }

  /// Compile-time type specification of [$BrowseSection]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/browse_section.dart',
    'BrowseSection',
  );

  /// Compile-time type declaration of [$BrowseSection]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$BrowseSection]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type, generics: {'T': BridgeGenericParam()}),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'id',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'title',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'externalUri',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'browseMore',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
              false,
            ),

            BridgeParameter(
              'items',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(BridgeTypeRef.ref('T')),
                ]),
              ),
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
      'id': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'title': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'externalUri': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'browseMore': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
        isStatic: false,
      ),

      'items': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(BridgeTypeRef.ref('T')),
          ]),
        ),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [BrowseSection.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $BrowseSection.wrap(
      BrowseSection(
        id: args[0]!.$value,
        title: args[1]!.$value,
        externalUri: args[2]!.$value,
        browseMore: args[3]!.$value,
        items: (args[4]!.$reified as List).cast(),
      ),
    );
  }

  final $Instance _superclass;

  @override
  final BrowseSection $value;

  @override
  BrowseSection get $reified => $value;

  /// Wrap a [BrowseSection] in a [$BrowseSection]
  $BrowseSection.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'id':
        final _id = $value.id;
        return $String(_id);

      case 'title':
        final _title = $value.title;
        return $String(_title);

      case 'externalUri':
        final _externalUri = $value.externalUri;
        return $String(_externalUri);

      case 'browseMore':
        final _browseMore = $value.browseMore;
        return $bool(_browseMore);

      case 'items':
        final _items = $value.items;
        return $List.view(_items, (e) => runtime.wrapAlways(e));
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
