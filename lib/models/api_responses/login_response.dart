import 'dart:developer';

import 'package:meta/meta.dart';

@immutable
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  bool get hasError => accessToken == null;

  const LoginResponse.success({
    @required this.accessToken,
    @required this.refreshToken,
    @required this.expiresIn,
  });

  const LoginResponse.error()
      : accessToken = null,
        refreshToken = null,
        expiresIn = null;

  factory LoginResponse.fromMap(Map<String, dynamic> response) {
    log('response: ${response.toString()}');
    try {
      return LoginResponse.success(
        accessToken: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'],
      );
    } catch (exception, stackTrace) {
      print('LoginResponse parsing ERROR: $exception');
      print(stackTrace);
      return const LoginResponse.error();
    }
  }
}
