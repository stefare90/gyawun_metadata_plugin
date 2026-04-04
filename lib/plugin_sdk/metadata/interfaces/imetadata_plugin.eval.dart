// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'imetadata_plugin.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iartist.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/ialbum.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iauth.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/ibrowse.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/icore.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iplaylist.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/isearch.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/itrack.eval.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iuser.eval.dart';

/// dart_eval wrapper binding for [IMetadataPlugin]
class $IMetadataPlugin implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$IMetadataPlugin]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/imetadata_plugin.dart',
    'IMetadataPlugin',
  );

  /// Compile-time type declaration of [$IMetadataPlugin]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$IMetadataPlugin]
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

    methods: {},
    getters: {
      'artist': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iartist.dart',
                'IArtist',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'album': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/ialbum.dart',
                'IAlbum',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'auth': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iauth.dart',
                'IAuth',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'browse': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/ibrowse.dart',
                'IBrowse',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'core': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/icore.dart',
                'ICore',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'playlist': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iplaylist.dart',
                'IPlaylist',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'search': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/isearch.dart',
                'ISearch',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'track': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/itrack.dart',
                'ITrack',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),

      'user': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(
              BridgeTypeSpec(
                'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/iuser.dart',
                'IUser',
              ),
              [],
            ),
          ),
          namedParams: [],
          params: [],
        ),
      ),
    },
    setters: {},
    fields: {},
    wrap: true,
    bridge: false,
  );

  final $Instance _superclass;

  @override
  final IMetadataPlugin $value;

  @override
  IMetadataPlugin get $reified => $value;

  /// Wrap a [IMetadataPlugin] in a [$IMetadataPlugin]
  $IMetadataPlugin.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'artist':
        final _artist = $value.artist;
        return $IArtist.wrap(_artist);

      case 'album':
        final _album = $value.album;
        return $IAlbum.wrap(_album);

      case 'auth':
        final _auth = $value.auth;
        return $IAuth.wrap(_auth);

      case 'browse':
        final _browse = $value.browse;
        return $IBrowse.wrap(_browse);

      case 'core':
        final _core = $value.core;
        return $ICore.wrap(_core);

      case 'playlist':
        final _playlist = $value.playlist;
        return $IPlaylist.wrap(_playlist);

      case 'search':
        final _search = $value.search;
        return $ISearch.wrap(_search);

      case 'track':
        final _track = $value.track;
        return $ITrack.wrap(_track);

      case 'user':
        final _user = $value.user;
        return $IUser.wrap(_user);
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
