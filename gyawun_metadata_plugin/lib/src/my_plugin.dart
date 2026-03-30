import 'package:gyawun_metadata_plugin/plugin_api/metadata_plugin_api.dart';

class MyPlugin implements IMetadataPlugin {
  @override
  // TODO: implement album
  IAlbum get album => throw UnimplementedError();

  @override
  // TODO: implement artist
  IArtist get artist => throw UnimplementedError();

  @override
  // TODO: implement auth
  IAuth get auth => throw UnimplementedError();

  @override
  // TODO: implement browse
  IBrowse get browse => throw UnimplementedError();

  @override
  // TODO: implement core
  ICore get core => throw UnimplementedError();

  @override
  // TODO: implement playlist
  IPlaylist get playlist => throw UnimplementedError();

  @override
  // TODO: implement search
  ISearch get search => throw UnimplementedError();

  @override
  // TODO: implement track
  ITrack get track => throw UnimplementedError();

  @override
  // TODO: implement user
  IUser get user => throw UnimplementedError();
}
