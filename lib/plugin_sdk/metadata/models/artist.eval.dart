// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'artist.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.eval.dart';

/// dart_eval wrapper binding for [Artist]
class $Artist implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.dart',
      'Artist.',
      $Artist.$new,
    );
  }

  /// Compile-time type specification of [$Artist]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.dart',
    'Artist',
  );

  /// Compile-time type declaration of [$Artist]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$Artist]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
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
              'name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'externalUri',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'images',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.dart',
                        'Image',
                      ),
                      [],
                    ),
                  ),
                ]),
              ),
              true,
            ),

            BridgeParameter(
              'genres',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                ]),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'followers',
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
      'id': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'name': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'externalUri': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'images': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec(
                  'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.dart',
                  'Image',
                ),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),

      'genres': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
          ]),
          nullable: true,
        ),
        isStatic: false,
      ),

      'followers': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, []), nullable: true),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [Artist.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $Artist.wrap(
      Artist(
        id: args[0]!.$value,
        name: args[1]!.$value,
        externalUri: args[2]!.$value,
        images: (args[3]?.$reified ?? const [] as List?)?.cast(),
        genres: (args[4]?.$reified as List?)?.cast(),
        followers: args[5]?.$value,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final Artist $value;

  @override
  Artist get $reified => $value;

  /// Wrap a [Artist] in a [$Artist]
  $Artist.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'id':
        final _id = $value.id;
        return $String(_id);

      case 'name':
        final _name = $value.name;
        return $String(_name);

      case 'externalUri':
        final _externalUri = $value.externalUri;
        return $String(_externalUri);

      case 'images':
        final _images = $value.images;
        return $List.view(_images, (e) => $Image.wrap(e));

      case 'genres':
        final _genres = $value.genres;
        return _genres == null
            ? const $null()
            : $List.view(_genres, (e) => $String(e));

      case 'followers':
        final _followers = $value.followers;
        return _followers == null ? const $null() : $int(_followers);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
