import 'package:gyawun_metadata_plugin/plugin_sdk/metadata_plugin_sdk.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';

class MusicbrainzPlugin implements IMetadataPlugin {
  late final String mbUrl;

  @override
  // TODO: implement album
  IAlbum get album => MusicbrainzAlbum(mbUrl);

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
