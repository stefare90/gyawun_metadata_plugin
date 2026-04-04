import '../models.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class INetworkService {
  Future<PluginResponse> send(PluginRequest request);
}
