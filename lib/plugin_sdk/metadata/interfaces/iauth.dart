import 'package:eval_annotation/eval_annotation.dart';

@Bind()
abstract class IAuth {
  Future<void> authenticate(String id) {
    throw Exception('Method not implemented.');
  }

  Future<void> logout() {
    throw Exception('Method not implemented.');
  }

  Future<bool> isAuthenticated() {
    throw Exception('Method not implemented.');
  }
}
