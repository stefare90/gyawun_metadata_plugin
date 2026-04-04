// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'iplaylist.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.eval.dart';

/// dart_eval wrapper binding for [IPlaylist]
class $IPlaylist implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$IPlaylist]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iplaylist.dart',
    'IPlaylist',
  );

  /// Compile-time type declaration of [$IPlaylist]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$IPlaylist]
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
      'getPlaylist': BridgeMethodDef(
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
          params: [
            BridgeParameter(
              'id',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'tracks': BridgeMethodDef(
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
          params: [
            BridgeParameter(
              'id',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'createPlaylist': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.dart',
                    'Playlist',
                  ),
                  [],
                ),
                nullable: true,
              ),
            ]),
          ),
          namedParams: [
            BridgeParameter(
              'description',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string, []),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'public_',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.bool, []),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'collaborative',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.bool, []),
                nullable: true,
              ),
              true,
            ),
          ],
          params: [
            BridgeParameter(
              'userId',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'name',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'updatePlaylist': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [
            BridgeParameter(
              'name',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string, []),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'description',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.string, []),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'public_',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.bool, []),
                nullable: true,
              ),
              true,
            ),

            BridgeParameter(
              'collaborative',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.bool, []),
                nullable: true,
              ),
              true,
            ),
          ],
          params: [
            BridgeParameter(
              'playlistId',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'deletePlaylist': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'playlistId',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'addTracks': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [
            BridgeParameter(
              'position',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.int, []),
                nullable: true,
              ),
              true,
            ),
          ],
          params: [
            BridgeParameter(
              'playlistId',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'trackIds',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                ]),
              ),
              false,
            ),
          ],
        ),
      ),

      'removeTracks': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'playlistId',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),

            BridgeParameter(
              'trackIds',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
                ]),
              ),
              false,
            ),
          ],
        ),
      ),

      'save': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'playlistId',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'unsave': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.voidType)),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'playlistId',
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
  final IPlaylist $value;

  @override
  IPlaylist get $reified => $value;

  /// Wrap a [IPlaylist] in a [$IPlaylist]
  $IPlaylist.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'getPlaylist':
        return __getPlaylist;

      case 'tracks':
        return __tracks;

      case 'createPlaylist':
        return __createPlaylist;

      case 'updatePlaylist':
        return __updatePlaylist;

      case 'deletePlaylist':
        return __deletePlaylist;

      case 'addTracks':
        return __addTracks;

      case 'removeTracks':
        return __removeTracks;

      case 'save':
        return __save;

      case 'unsave':
        return __unsave;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __getPlaylist = $Function(_getPlaylist);
  static $Value? _getPlaylist(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IPlaylist;
    final result = self.$value.getPlaylist(args[0]!.$value);
    return $Future.wrap(result.then((e) => $Map.wrap(e)));
  }

  static const $Function __tracks = $Function(_tracks);
  static $Value? _tracks(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IPlaylist;
    final result = self.$value.tracks(
      args[0]!.$value,
      offset: args[1]?.$value ?? 0,
      limit: args[2]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __createPlaylist = $Function(_createPlaylist);
  static $Value? _createPlaylist(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IPlaylist;
    final result = self.$value.createPlaylist(
      args[0]!.$value,
      args[1]!.$value,
      description: args[2]?.$value,
      public_: args[3]?.$value,
      collaborative: args[4]?.$value,
    );
    return $Future.wrap(
      result.then((e) => e == null ? const $null() : $Playlist.wrap(e)),
    );
  }

  static const $Function __updatePlaylist = $Function(_updatePlaylist);
  static $Value? _updatePlaylist(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IPlaylist;
    final result = self.$value.updatePlaylist(
      args[0]!.$value,
      name: args[1]?.$value,
      description: args[2]?.$value,
      public_: args[3]?.$value,
      collaborative: args[4]?.$value,
    );
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __deletePlaylist = $Function(_deletePlaylist);
  static $Value? _deletePlaylist(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IPlaylist;
    final result = self.$value.deletePlaylist(args[0]!.$value);
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __addTracks = $Function(_addTracks);
  static $Value? _addTracks(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IPlaylist;
    final result = self.$value.addTracks(
      args[0]!.$value,
      (args[1]!.$reified as List).cast(),
      position: args[2]?.$value,
    );
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __removeTracks = $Function(_removeTracks);
  static $Value? _removeTracks(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IPlaylist;
    final result = self.$value.removeTracks(
      args[0]!.$value,
      (args[1]!.$reified as List).cast(),
    );
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __save = $Function(_save);
  static $Value? _save(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IPlaylist;
    final result = self.$value.save(args[0]!.$value);
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __unsave = $Function(_unsave);
  static $Value? _unsave(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IPlaylist;
    final result = self.$value.unsave(args[0]!.$value);
    return $Future.wrap(result.then((e) => null));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
