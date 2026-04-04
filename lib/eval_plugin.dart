import 'package:dart_eval/dart_eval_bridge.dart';
import 'plugin_sdk/metadata/models/track.eval.dart';
import 'plugin_sdk/metadata/models/pagination.eval.dart';
import 'plugin_sdk/metadata/models/playlist.eval.dart';
import 'plugin_sdk/metadata/models/artist.eval.dart';
import 'plugin_sdk/metadata/models/section.eval.dart';
import 'plugin_sdk/metadata/models/search.eval.dart';
import 'plugin_sdk/metadata/models/browse_section.eval.dart';
import 'plugin_sdk/metadata/models/album.eval.dart';
import 'plugin_sdk/metadata/models/plugin_response.eval.dart';
import 'plugin_sdk/metadata/models/user.eval.dart';
import 'plugin_sdk/metadata/models/image.eval.dart';
import 'plugin_sdk/metadata/models/plugin_request.eval.dart';
import 'plugin_sdk/metadata/interfaces/itrack.eval.dart';
import 'plugin_sdk/metadata/interfaces/iplaylist.eval.dart';
import 'plugin_sdk/metadata/interfaces/ialbum.eval.dart';
import 'plugin_sdk/metadata/interfaces/iuser.eval.dart';
import 'plugin_sdk/metadata/interfaces/isearch.eval.dart';
import 'plugin_sdk/metadata/interfaces/icore.eval.dart';
import 'plugin_sdk/metadata/interfaces/inetwork_service.eval.dart';
import 'plugin_sdk/metadata/interfaces/ibrowse.eval.dart';
import 'plugin_sdk/metadata/interfaces/iartist.eval.dart';
import 'plugin_sdk/metadata/interfaces/iauth.eval.dart';
import 'plugin_sdk/metadata/interfaces/imetadata_plugin.eval.dart';

/// [EvalPlugin] for gyawun_metadata_plugin
class GyawunMetadataPluginPlugin implements EvalPlugin {
  @override
  String get identifier => 'package:gyawun_metadata_plugin';

  @override
  void configureForCompile(BridgeDeclarationRegistry registry) {
    registry.defineBridgeClass($Track.$declaration);
    registry.defineBridgeClass($PaginatedResult.$declaration);
    registry.defineBridgeClass($Playlist.$declaration);
    registry.defineBridgeClass($Artist.$declaration);
    registry.defineBridgeClass($Section.$declaration);
    registry.defineBridgeClass($SearchResponse.$declaration);
    registry.defineBridgeClass($BrowseSection.$declaration);
    registry.defineBridgeClass($Album.$declaration);
    registry.defineBridgeClass($PluginResponse.$declaration);
    registry.defineBridgeClass($User.$declaration);
    registry.defineBridgeClass($Image.$declaration);
    registry.defineBridgeClass($PluginRequest.$declaration);
    registry.defineBridgeClass($ITrack.$declaration);
    registry.defineBridgeClass($IPlaylist.$declaration);
    registry.defineBridgeClass($IAlbum.$declaration);
    registry.defineBridgeClass($IUser.$declaration);
    registry.defineBridgeClass($ISearch.$declaration);
    registry.defineBridgeClass($ICore.$declaration);
    registry.defineBridgeClass($INetworkService.$declaration);
    registry.defineBridgeClass($IBrowse.$declaration);
    registry.defineBridgeClass($IArtist.$declaration);
    registry.defineBridgeClass($IAuth.$declaration);
    registry.defineBridgeClass($IMetadataPlugin.$declaration);
    registry.defineBridgeEnum($AlbumType.$declaration);
  }

  @override
  void configureForRuntime(Runtime runtime) {
    $Track.configureForRuntime(runtime);
    $PaginatedResult.configureForRuntime(runtime);
    $Playlist.configureForRuntime(runtime);
    $Artist.configureForRuntime(runtime);
    $Section.configureForRuntime(runtime);
    $SearchResponse.configureForRuntime(runtime);
    $BrowseSection.configureForRuntime(runtime);
    $Album.configureForRuntime(runtime);
    $PluginResponse.configureForRuntime(runtime);
    $User.configureForRuntime(runtime);
    $Image.configureForRuntime(runtime);
    $PluginRequest.configureForRuntime(runtime);
    $ITrack.configureForRuntime(runtime);
    $IPlaylist.configureForRuntime(runtime);
    $IAlbum.configureForRuntime(runtime);
    $IUser.configureForRuntime(runtime);
    $ISearch.configureForRuntime(runtime);
    $ICore.configureForRuntime(runtime);
    $INetworkService.configureForRuntime(runtime);
    $IBrowse.configureForRuntime(runtime);
    $IArtist.configureForRuntime(runtime);
    $IAuth.configureForRuntime(runtime);
    $IMetadataPlugin.configureForRuntime(runtime);
    $AlbumType.configureForRuntime(runtime);
  }
}
