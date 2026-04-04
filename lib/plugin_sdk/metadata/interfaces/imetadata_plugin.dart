// To move in a dedicated repository for the plugin API
//to share it between the plugin and the main application
//without creating a dependency from the plugin to the main application.
//This is useful to avoid circular dependencies and to keep the plugin API
//independent from the main application.

import 'package:gyawun_metadata_plugin/plugin_sdk/metadata/interfaces.dart';

import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IMetadataPlugin {
  IArtist get artist;
  IAlbum get album;
  IAuth get auth;
  IBrowse get browse;
  ICore get core;
  IPlaylist get playlist;
  ISearch get search;
  ITrack get track;
  IUser get user;
}
