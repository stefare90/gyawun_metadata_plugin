// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'iuser.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.eval.dart';

/// dart_eval wrapper binding for [IUser]
class $IUser implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$IUser]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iuser.dart',
    'IUser',
  );

  /// Compile-time type declaration of [$IUser]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$IUser]
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
      'me': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.map, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.dynamic)),
                ]),
              ),
            ]),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'savedTracks': BridgeMethodDef(
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
                          'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.dart',
                          'Track',
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

      'savedAlbums': BridgeMethodDef(
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
                          'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
                          'Album',
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

      'savedArtists': BridgeMethodDef(
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
                          'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.dart',
                          'Artist',
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

      'savedPlaylists': BridgeMethodDef(
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
                          'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.dart',
                          'Playlist',
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
    },
    getters: {},
    setters: {},
    fields: {},
    wrap: true,
    bridge: false,
  );

  final $Instance _superclass;

  @override
  final IUser $value;

  @override
  IUser get $reified => $value;

  /// Wrap a [IUser] in a [$IUser]
  $IUser.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'me':
        return __me;

      case 'savedTracks':
        return __savedTracks;

      case 'savedAlbums':
        return __savedAlbums;

      case 'savedArtists':
        return __savedArtists;

      case 'savedPlaylists':
        return __savedPlaylists;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __me = $Function(_me);
  static $Value? _me(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IUser;
    final result = self.$value.me();
    return $Future.wrap(result.then((e) => $Map.wrap(e)));
  }

  static const $Function __savedTracks = $Function(_savedTracks);
  static $Value? _savedTracks(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IUser;
    final result = self.$value.savedTracks(
      offset: args[0]?.$value ?? 0,
      limit: args[1]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __savedAlbums = $Function(_savedAlbums);
  static $Value? _savedAlbums(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IUser;
    final result = self.$value.savedAlbums(
      offset: args[0]?.$value ?? 0,
      limit: args[1]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __savedArtists = $Function(_savedArtists);
  static $Value? _savedArtists(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IUser;
    final result = self.$value.savedArtists(
      offset: args[0]?.$value ?? 0,
      limit: args[1]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __savedPlaylists = $Function(_savedPlaylists);
  static $Value? _savedPlaylists(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IUser;
    final result = self.$value.savedPlaylists(
      offset: args[0]?.$value ?? 0,
      limit: args[1]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
