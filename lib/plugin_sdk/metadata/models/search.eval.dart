// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'search.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/album.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/artist.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.eval.dart';

/// dart_eval wrapper binding for [SearchResponse]
class $SearchResponse implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {
    runtime.registerBridgeFunc(
      'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/search.dart',
      'SearchResponse.',
      $SearchResponse.$new,
    );
  }

  /// Compile-time type specification of [$SearchResponse]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/search.dart',
    'SearchResponse',
  );

  /// Compile-time type declaration of [$SearchResponse]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$SearchResponse]
  static const $declaration = BridgeClassDef(
    BridgeClassType($type),
    constructors: {
      '': BridgeConstructorDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation($type),
          namedParams: [
            BridgeParameter(
              'albums',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
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
              'playlists',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.dart',
                        'Playlist',
                      ),
                      [],
                    ),
                  ),
                ]),
              ),
              false,
            ),

            BridgeParameter(
              'tracks',
              BridgeTypeAnnotation(
                BridgeTypeRef(CoreTypes.list, [
                  BridgeTypeAnnotation(
                    BridgeTypeRef(
                      BridgeTypeSpec(
                        'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.dart',
                        'Track',
                      ),
                      [],
                    ),
                  ),
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
      'albums': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
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

      'playlists': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec(
                  'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/playlist.dart',
                  'Playlist',
                ),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),

      'tracks': BridgeFieldDef(
        BridgeTypeAnnotation(
          BridgeTypeRef(CoreTypes.list, [
            BridgeTypeAnnotation(
              BridgeTypeRef(
                BridgeTypeSpec(
                  'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.dart',
                  'Track',
                ),
                [],
              ),
            ),
          ]),
        ),
        isStatic: false,
      ),
    },
    wrap: true,
    bridge: false,
  );

  /// Wrapper for the [SearchResponse.new] constructor
  static $Value? $new(Runtime runtime, $Value? thisValue, List<$Value?> args) {
    return $SearchResponse.wrap(
      SearchResponse(
        albums: (args[0]!.$reified as List).cast(),
        artists: (args[1]!.$reified as List).cast(),
        playlists: (args[2]!.$reified as List).cast(),
        tracks: (args[3]!.$reified as List).cast(),
      ),
    );
  }

  final $Instance _superclass;

  @override
  final SearchResponse $value;

  @override
  SearchResponse get $reified => $value;

  /// Wrap a [SearchResponse] in a [$SearchResponse]
  $SearchResponse.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'albums':
        final _albums = $value.albums;
        return $List.view(_albums, (e) => $Album.wrap(e));

      case 'artists':
        final _artists = $value.artists;
        return $List.view(_artists, (e) => $Artist.wrap(e));

      case 'playlists':
        final _playlists = $value.playlists;
        return $List.view(_playlists, (e) => $Playlist.wrap(e));

      case 'tracks':
        final _tracks = $value.tracks;
        return $List.view(_tracks, (e) => $Track.wrap(e));
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
