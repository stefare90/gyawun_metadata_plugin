// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'album.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/image.eval.dart';

/// dart_eval enum wrapper binding for [AlbumType]
class $AlbumType implements $Instance {
  /// Configure this enum for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeEnumValues(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
      'AlbumType',
      $AlbumType._$values,
    );

    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
      'AlbumType.values*g',
      $AlbumType.$values,
    );
  }

  /// Compile-time type specification of [$AlbumType]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
    'AlbumType',
  );

  /// Compile-time type declaration of [$AlbumType]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$AlbumType]
  static const $declaration = BridgeEnumDef(
    $type,

    values: ['album', 'single', 'compilation'],

    methods: {},
    getters: {},
    setters: {},
    fields: {},
  );

  static final _$values = {
    'album': $AlbumType.wrap(AlbumType.album),
    'single': $AlbumType.wrap(AlbumType.single),
    'compilation': $AlbumType.wrap(AlbumType.compilation),
  };

  /// Wrapper for the [AlbumType.values] getter
  static $Value? $values(Runtime runtime, $Value? target, List<$Value?> args) {
    final value = AlbumType.values;
    return $List.view(value, (e) => $AlbumType.wrap(e));
  }

  final $Instance _superclass;

  @override
  final AlbumType $value;

  @override
  AlbumType get $reified => $value;

  /// Wrap a [AlbumType] in a [$AlbumType]
  $AlbumType.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}

/// dart_eval wrapper binding for [Album]
class $Album implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
      'Album.',
      $Album.$new,
    );
  }

  /// Compile-time type specification of [$Album]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
    'Album',
  );

  /// Compile-time type declaration of [$Album]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$Album]
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
              'releaseDate',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'externalUri',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'totalTracks',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
              false,
            ),

            BridgeParameter(
              'albumType',
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
                    'AlbumType',
                  ),
                  [],
                ),
              ),
              false,
            ),

            BridgeParameter(
              'recordLabel',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string, []),
                nullable: true,
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
          ],
          params: [],
        ),
        isFactory: true,
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

      'releaseDate': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'externalUri': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
        isStatic: false,
      ),

      'totalTracks': BridgeFieldDef(
        BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.int, [])),
        isStatic: false,
      ),

      'albumType': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(
            BridgeTypeSpec(
              'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
              'AlbumType',
            ),
            [],
          ),
        ),
        isStatic: false,
      ),

      'recordLabel': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.string, []),
          nullable: true,
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
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [Album.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $Album.wrap(
      Album(
        id: args[0]!.$value,
        name: args[1]!.$value,
        artists: (args[2]!.$reified as List).cast(),
        images: (args[3]?.$reified ?? const [] as List?)?.cast(),
        releaseDate: args[4]!.$value,
        externalUri: args[5]!.$value,
        totalTracks: args[6]!.$value,
        albumType: args[7]!.$value,
        recordLabel: args[8]?.$value,
        genres: (args[9]?.$reified as List?)?.cast(),
      ),
    );
  }

  final $Instance _superclass;

  @override
  final Album $value;

  @override
  Album get $reified => $value;

  /// Wrap a [Album] in a [$Album]
  $Album.wrap(this.$value) : _superclass = $Object($value);

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

      case 'artists':
        final _artists = $value.artists;
        return $List.view(_artists, (e) => $Artist.wrap(e));

      case 'images':
        final _images = $value.images;
        return $List.view(_images, (e) => $Image.wrap(e));

      case 'releaseDate':
        final _releaseDate = $value.releaseDate;
        return $String(_releaseDate);

      case 'externalUri':
        final _externalUri = $value.externalUri;
        return $String(_externalUri);

      case 'totalTracks':
        final _totalTracks = $value.totalTracks;
        return $int(_totalTracks);

      case 'albumType':
        final _albumType = $value.albumType;
        return $AlbumType.wrap(_albumType);

      case 'recordLabel':
        final _recordLabel = $value.recordLabel;
        return _recordLabel == null ? const $null() : $String(_recordLabel);

      case 'genres':
        final _genres = $value.genres;
        return _genres == null
            ? const $null()
            : $List.view(_genres, (e) => $String(e));
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
