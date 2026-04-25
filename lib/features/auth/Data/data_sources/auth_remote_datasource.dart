import 'package:evo_project/core/network/response_wrapper.dart';
import 'package:evo_project/core/services/user_seesion.dart';

class AuthRemoteDatasource {
  final UserSeesion userSeesion;
  AuthRemoteDatasource({required this.userSeesion});

  Future<ResponseWrapper> signIn({
    required String email,
    required String password,
  }) async {
    return userSeesion.signIn(email: email, password: password);
  }

  Future<ResponseWrapper> logout({required String customerToken}) async {
    return userSeesion.logout(customerToken: customerToken);
  }
}
