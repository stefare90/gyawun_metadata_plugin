// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'isearch.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/search.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.eval.dart';

/// dart_eval wrapper binding for [ISearch]
class $ISearch implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$ISearch]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/isearch.dart',
    'ISearch',
  );

  /// Compile-time type declaration of [$ISearch]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$ISearch]
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
      'chips': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.list, [
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
            ]),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'all': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/search.dart',
                    'SearchResponse',
                  ),
                  [],
                ),
              ),
            ]),
          ),
          namedParams: [],
          params: [
            BridgeParameter(
              'query',
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
              'query',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'albums': BridgeMethodDef(
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
          params: [
            BridgeParameter(
              'query',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'artists': BridgeMethodDef(
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
          params: [
            BridgeParameter(
              'query',
              BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.string, [])),
              false,
            ),
          ],
        ),
      ),

      'playlists': BridgeMethodDef(
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
          params: [
            BridgeParameter(
              'query',
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
  final ISearch $value;

  @override
  ISearch get $reified => $value;

  /// Wrap a [ISearch] in a [$ISearch]
  $ISearch.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'chips':
        return __chips;

      case 'all':
        return __all;

      case 'tracks':
        return __tracks;

      case 'albums':
        return __albums;

      case 'artists':
        return __artists;

      case 'playlists':
        return __playlists;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __chips = $Function(_chips);
  static $Value? _chips(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ISearch;
    final result = self.$value.chips();
    return $List.view(result, (e) => $String(e));
  }

  static const $Function __all = $Function(_all);
  static $Value? _all(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ISearch;
    final result = self.$value.all(args[0]!.$value);
    return $Future.wrap(result.then((e) => $SearchResponse.wrap(e)));
  }

  static const $Function __tracks = $Function(_tracks);
  static $Value? _tracks(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ISearch;
    final result = self.$value.tracks(
      args[0]!.$value,
      offset: args[1]?.$value ?? 0,
      limit: args[2]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __albums = $Function(_albums);
  static $Value? _albums(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ISearch;
    final result = self.$value.albums(
      args[0]!.$value,
      offset: args[1]?.$value ?? 0,
      limit: args[2]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __artists = $Function(_artists);
  static $Value? _artists(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ISearch;
    final result = self.$value.artists(
      args[0]!.$value,
      offset: args[1]?.$value ?? 0,
      limit: args[2]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __playlists = $Function(_playlists);
  static $Value? _playlists(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $ISearch;
    final result = self.$value.playlists(
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
