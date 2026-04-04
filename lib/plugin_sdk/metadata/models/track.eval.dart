// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'track.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.eval.dart';

/// dart_eval wrapper binding for [Track]
class $Track implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.dart',
      'Track.',
      $Track.$new,
    );
  }

  /// Compile-time type specification of [$Track]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.dart',
    'Track',
  );

  /// Compile-time type declaration of [$Track]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$Track]
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
              'artists',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.dart',
                        'Artist',
                      ),
                      [],
                    ),
                  ),
                ]),
              ),
              true,
            ),

            BridgeParameter(
              'album',
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
                    'Album',
                  ),
                  [],
                ),
              ),
              false,
            ),

            BridgeParameter(
              'durationMs',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'path',
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

      'artists': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec(
                  'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.dart',
                  'Artist',
                ),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),

      'album': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(
            BridgeTypeSpec(
              'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
              'Album',
            ),
            [],
          ),
        ),
        isStatic: false,
      ),

      'durationMs': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'path': BridgeFieldDef(
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

  /// Wrapper for the [Track.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $Track.wrap(
      Track(
        id: args[0]!.$value,
        name: args[1]!.$value,
        externalUri: args[2]!.$value,
        artists: (args[3]?.$reified ?? const [] as List?)?.cast(),
        album: args[4]!.$value,
        durationMs: args[5]!.$value,
        path: args[6]?.$value,
      ),
    );
  }

  final $Instance _superclass;

  @override
  final Track $value;

  @override
  Track get $reified => $value;

  /// Wrap a [Track] in a [$Track]
  $Track.wrap(this.$value) : _superclass = $Object($value);

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

      case 'artists':
        final _artists = $value.artists;
        return $List.view(_artists, (e) => $Artist.wrap(e));

      case 'album':
        final _album = $value.album;
        return $Album.wrap(_album);

      case 'durationMs':
        final _durationMs = $value.durationMs;
        return $int(_durationMs);

      case 'path':
        final _path = $value.path;
        return _path == null ? const $null() : $String(_path);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
