import 'package:flutter/material.dart';
import 'package:mintness/models/api_responses/login_response.dart';
import 'package:mintness/repositories/api.dart';
import 'package:mintness/repositories/local_storage.dart';

class AuthProvider extends ChangeNotifier {

  Future<bool> login({
    @required String email,
    @required String password,
    bool staySignedIn,
    BuildContext context}) async {
    LoginResponse response =
        await Api().login(email: email, password: password,staySignedIn: staySignedIn, context: context);
    if(response?.hasError??true) return (!response?.hasError);
    LocalStorage().saveAccessToken(response?.accessToken);
    LocalStorage().saveRefreshToken(response?.refreshToken);
    return (response?.hasError) != null;
  }


  Future<bool> logout() async {
    LocalStorage().deleteAccessToken();
    LocalStorage().deleteRefreshToken();
    return true;
  }
}
