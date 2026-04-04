// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'ialbum.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/pagination.eval.dart';

/// dart_eval wrapper binding for [IAlbum]
class $IAlbum implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$IAlbum]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/ialbum.dart',
    'IAlbum',
  );

  /// Compile-time type declaration of [$IAlbum]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$IAlbum]
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
      'getAlbum': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
              BridgeTypeAnnotation(
                BridgeTypeRef(
                  BridgeTypeSpec(
                    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.dart',
                    'Album',
                  ),
                  [],
                ),
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

      'releases': BridgeMethodDef(
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
              'ids',
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
              'ids',
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
    },
    getters: {},
    setters: {},
    fields: {},
    wrap: true,
    bridge: false,
  );

  final $Instance _superclass;

  @override
  final IAlbum $value;

  @override
  IAlbum get $reified => $value;

  /// Wrap a [IAlbum] in a [$IAlbum]
  $IAlbum.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'getAlbum':
        return __getAlbum;

      case 'tracks':
        return __tracks;

      case 'releases':
        return __releases;

      case 'save':
        return __save;

      case 'unsave':
        return __unsave;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __getAlbum = $Function(_getAlbum);
  static $Value? _getAlbum(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IAlbum;
    final result = self.$value.getAlbum(args[0]!.$value);
    return $Future.wrap(result.then((e) => $Album.wrap(e)));
  }

  static const $Function __tracks = $Function(_tracks);
  static $Value? _tracks(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IAlbum;
    final result = self.$value.tracks(
      args[0]!.$value,
      offset: args[1]?.$value ?? 0,
      limit: args[2]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __releases = $Function(_releases);
  static $Value? _releases(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $IAlbum;
    final result = self.$value.releases(
      offset: args[0]?.$value ?? 0,
      limit: args[1]?.$value ?? 20,
    );
    return $Future.wrap(result.then((e) => $PaginatedResult.wrap(e)));
  }

  static const $Function __save = $Function(_save);
  static $Value? _save(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IAlbum;
    final result = self.$value.save((args[0]!.$reified as List).cast());
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __unsave = $Function(_unsave);
  static $Value? _unsave(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $IAlbum;
    final result = self.$value.unsave((args[0]!.$reified as List).cast());
    return $Future.wrap(result.then((e) => null));
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
