import 'package:gyawun_metadata_sdk/metadata/interfaces/istorage_service.dart';

class StorageService implements IStorageService {
  final box = {};

  @override
  Future<void> clear() async {
    box.clear();
  }

  @override
  Future<void> delete(String key) async {
    box.remove(key);
  }

  @override
  Future<String?> get(String key) async {
    return box[key];
  }

  @override
  Future<void> set(String key, String value) async {
    box[key] = value;
  }
}
