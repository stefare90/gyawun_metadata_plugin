import 'package:gyawun_metadata_plugin/segments/artist.dart';
import 'package:gyawun_metadata_plugin/segments/auth.dart';
import 'package:gyawun_metadata_plugin/segments/browse.dart';
import 'package:gyawun_metadata_plugin/segments/core.dart';
import 'package:gyawun_metadata_plugin/segments/playlist.dart';
import 'package:gyawun_metadata_plugin/segments/search.dart';
import 'package:gyawun_metadata_plugin/segments/track.dart';
import 'package:gyawun_metadata_plugin/segments/user.dart';
import 'package:gyawun_metadata_plugin/segments/album.dart';
import 'package:gyawun_metadata_sdk/metadata/host_env.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/ialbum.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iartist.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iauth.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/ibrowse.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/icore.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/imetadata_plugin.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iplaylist.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/isearch.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/itrack.dart';
import 'package:gyawun_metadata_sdk/metadata/interfaces/iuser.dart';

class MusicbrainzPlugin extends IMetadataPlugin {
  final String mbUrl = 'https://musicbrainz.org/ws/2/';
  final HostEnv hostEnv;

  MusicbrainzPlugin({required this.hostEnv});

  @override
  // TODO: implement album
  IAlbum get album => MusicbrainzAlbum(mbUrl, hostEnv);

  @override
  // TODO: implement artist
  IArtist get artist => MusicbrainzArtist();

  @override
  // TODO: implement auth
  IAuth get auth => MusicbrainzAuth();

  @override
  // TODO: implement browse
  IBrowse get browse => MusicbrainzBrowse();

  @override
  // TODO: implement core
  ICore get core => MusicbrainzCore();

  @override
  // TODO: implement playlist
  IPlaylist get playlist => MusicbrainzPlaylist();

  @override
  // TODO: implement search
  ISearch get search => MusicbrainzSearch();

  @override
  // TODO: implement track
  ITrack get track => MusicbrainzTrack();

  @override
  // TODO: implement user
  IUser get user => MusicbrainzUser();
}
