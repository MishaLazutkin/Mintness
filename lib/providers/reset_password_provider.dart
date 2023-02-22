import 'package:flutter/material.dart';
import 'package:mintness/repositories/api.dart';

class ResetPasswordProvider extends ChangeNotifier {
  void sendVerifyCode(String email) async {
    await Api().getSmsCode(email);
  }

  Future<bool> verifyCode(String code) async {
    bool success = await Api().verifySmsCode(code);
    return success;
  }
  Future<bool> resetPassword(String code,String password) async {
    bool success = await Api().resetPassword(code,password);
    return success;
  }

}
