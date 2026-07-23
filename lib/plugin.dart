import 'package:gyawun_metadata_plugin/segments/artist.dart';
import 'package:gyawun_metadata_plugin/segments/auth.dart';
import 'package:gyawun_metadata_plugin/segments/browse.dart';
import 'package:gyawun_metadata_plugin/segments/core.dart';
import 'package:gyawun_metadata_plugin/segments/host_tools.dart';
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
  static const String mbUrl = 'https://musicbrainz.org/ws/2/';
  static const String mbUriBase = 'https://musicbrainz.org/';
  static const String lbUrl = 'https://api.listenbrainz.org/1/';
  static const String lbLabsUrl = 'https://labs.api.listenbrainz.org';

  late HostEnv hostEnv;
  late MusicbrainzAuth _auth;
  late MusicbrainzUser _user;
  late MusicbrainzAlbum _album;
  late MusicbrainzArtist _artist;
  late MusicbrainzBrowse _browse;
  late MusicbrainzCore _core;
  late MusicbrainzPlaylist _playlist;
  late MusicbrainzSearch _search;
  late MusicbrainzTrack _track;

  MusicbrainzPlugin({required this.hostEnv}) {
    final host = HostTools(hostEnv);
    _auth = MusicbrainzAuth(host);
    _user = MusicbrainzUser(_auth, host);
    _album = MusicbrainzAlbum(host, _user);
    _artist = MusicbrainzArtist(host, _user);
    _browse = MusicbrainzBrowse();
    _core = MusicbrainzCore();
    _playlist = MusicbrainzPlaylist(host, _user);
    _search = MusicbrainzSearch();
    _track = MusicbrainzTrack(host, _user);
  }

  @override
  IAuth get auth => _auth;

  @override
  IUser get user => _user;

  @override
  IAlbum get album => _album;

  @override
  IArtist get artist => _artist;

  @override
  IBrowse get browse => _browse;

  @override
  ICore get core => _core;

  @override
  IPlaylist get playlist => _playlist;

  @override
  ISearch get search => _search;

  @override
  ITrack get track => _track;
}
