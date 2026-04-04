// ignore_for_file: unused_import, unnecessary_import
// ignore_for_file: always_specify_types, avoid_redundant_argument_values
// ignore_for_file: sort_constructors_first
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'itrack.dart';
import '../models.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:dart_eval/stdlib/async.dart';
import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/models/track.eval.dart';

/// dart_eval wrapper binding for [ITrack]
class $ITrack implements $Instance {
  /// Configure this class for use in a [Runtime]
  static void configureForRuntime(Runtime runtime) {}

  /// Compile-time type specification of [$ITrack]
  static const $spec = BridgeTypeSpec(
    'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces/itrack.dart',
    'ITrack',
  );

  /// Compile-time type declaration of [$ITrack]
  static const $type = BridgeTypeRef($spec);

  /// Compile-time class declaration of [$ITrack]
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
      'getTrack': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
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

      'radio': BridgeMethodDef(
        BridgeFunctionDef(
          returns: BridgeTypeAnnotation(
            BridgeTypeRef(CoreTypes.future, [
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
    },
    getters: {},
    setters: {},
    fields: {},
    wrap: true,
    bridge: false,
  );

  final $Instance _superclass;

  @override
  final ITrack $value;

  @override
  ITrack get $reified => $value;

  /// Wrap a [ITrack] in a [$ITrack]
  $ITrack.wrap(this.$value) : _superclass = $Object($value);

  @override
  int $getRuntimeType(Runtime runtime) => runtime.lookupType($spec);

  @override
  $Value? $getProperty(Runtime runtime, String identifier) {
    switch (identifier) {
      case 'getTrack':
        return __getTrack;

      case 'save':
        return __save;

      case 'unsave':
        return __unsave;

      case 'radio':
        return __radio;
    }
    return _superclass.$getProperty(runtime, identifier);
  }

  static const $Function __getTrack = $Function(_getTrack);
  static $Value? _getTrack(
    Runtime runtime,
    $Value? target,
    List<$Value?> args,
  ) {
    final self = target! as $ITrack;
    final result = self.$value.getTrack(args[0]!.$value);
    return $Future.wrap(result.then((e) => $Track.wrap(e)));
  }

  static const $Function __save = $Function(_save);
  static $Value? _save(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ITrack;
    final result = self.$value.save((args[0]!.$reified as List).cast());
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __unsave = $Function(_unsave);
  static $Value? _unsave(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ITrack;
    final result = self.$value.unsave((args[0]!.$reified as List).cast());
    return $Future.wrap(result.then((e) => null));
  }

  static const $Function __radio = $Function(_radio);
  static $Value? _radio(Runtime runtime, $Value? target, List<$Value?> args) {
    final self = target! as $ITrack;
    final result = self.$value.radio(args[0]!.$value);
    return $Future.wrap(
      result.then((e) => $List.view(e, (e) => $Track.wrap(e))),
    );
  }

  @override
  void $setProperty(Runtime runtime, String identifier, $Value value) {
    return _superclass.$setProperty(runtime, identifier, value);
  }
}
