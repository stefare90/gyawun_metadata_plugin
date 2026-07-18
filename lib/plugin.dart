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
  late String _mbUrl;
  late String _mbUriBase;
  late String _lbUrl;
  late String _lbLabsUrl;
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
    _lbUrl = "https://api.listenbrainz.org/1/";
    _lbLabsUrl = "https://labs.api.listenbrainz.org";
    _mbUrl = 'https://musicbrainz.org/ws/2/';
    _mbUriBase = 'https://musicbrainz.org/';
    final host = HostTools(hostEnv);
    _auth = MusicbrainzAuth(_mbUrl, _mbUriBase, host);
    _user = MusicbrainzUser(_auth, _lbUrl, _mbUriBase, host);
    _album = MusicbrainzAlbum(_mbUrl, _mbUriBase, host, _user);
    _artist = MusicbrainzArtist(
      _mbUrl,
      _mbUriBase,
      _lbUrl,
      _lbLabsUrl,
      host,
      _user,
    );
    _browse = MusicbrainzBrowse();
    _core = MusicbrainzCore();
    _playlist = MusicbrainzPlaylist();
    _search = MusicbrainzSearch();
    _track = MusicbrainzTrack();
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
