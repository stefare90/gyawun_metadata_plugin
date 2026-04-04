// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'playlist.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/user.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.eval.dart';

/// dart_eval wrapper binding for [Playlist]
class $Playlist implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.dart',
      'Playlist.',
      $Playlist.$new,
    );
  }

  /// Compile-time type specification of [$Playlist]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.dart',
    'Playlist',
  );

  /// Compile-time type declaration of [$Playlist]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$Playlist]
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
              'description',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'externalUri',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'owner',
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/user.dart',
                    'User',
                  ),
                  [],
                ),
              ),
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
              'collaborators',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/user.dart',
                        'User',
                      ),
                      [],
                    ),
                  ),
                ]),
              ),
              true,
            ),

            BridgeParameter(
              'collaborative',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
              true,
            ),

            BridgeParameter(
              'isPublic',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
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

      'description': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'externalUri': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'owner': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(
            BridgeTypeSpec(
              'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/user.dart',
              'User',
            ),
            [],
          ),
        ),
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

      'collaborators': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec(
                  'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/user.dart',
                  'User',
                ),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),

      'collaborative': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
        isStatic: false,
      ),

      'isPublic': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.bool, [])),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [Playlist.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $Playlist.wrap(
      Playlist(
        id: args[0]!.$value,
        name: args[1]!.$value,
        description: args[2]!.$value,
        externalUri: args[3]!.$value,
        owner: args[4]!.$value,
        images: (args[5]?.$reified ?? const [] as List?)?.cast(),
        collaborators: (args[6]?.$reified ?? const [] as List?)?.cast(),
        collaborative: args[7]?.$value ?? false,
        isPublic: args[8]?.$value ?? false,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final Playlist $value;

  @override
  Playlist get $reified => $value;

  /// Wrap a [Playlist] in a [$Playlist]
  $Playlist.wrap(this.$value) : _superclass = $Object($value);

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

      case 'description':
        final _description = $value.description;
        return $String(_description);

      case 'externalUri':
        final _externalUri = $value.externalUri;
        return $String(_externalUri);

      case 'owner':
        final _owner = $value.owner;
        return $User.wrap(_owner);

      case 'images':
        final _images = $value.images;
        return $List.view(_images, (e) => $Image.wrap(e));

      case 'collaborators':
        final _collaborators = $value.collaborators;
        return $List.view(_collaborators, (e) => $User.wrap(e));

      case 'collaborative':
        final _collaborative = $value.collaborative;
        return $bool(_collaborative);

      case 'isPublic':
        final _isPublic = $value.isPublic;
        return $bool(_isPublic);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
