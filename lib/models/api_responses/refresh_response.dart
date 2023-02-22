import 'dart:developer';

import 'package:meta/meta.dart';

@immutable
class RefreshResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  bool get hasError => accessToken == null;

  const RefreshResponse.success({
    @required this.accessToken,
    @required this.refreshToken,
    @required this.expiresIn,
  });

  const RefreshResponse.error()
      : accessToken = null,
        refreshToken = null,
        expiresIn = null;

  factory RefreshResponse.fromMap(Map<String, dynamic> response) {
    log('response: ${response.toString()}');
    try {
      return RefreshResponse.success(
        accessToken: response['access_token'],
        refreshToken: response['refresh_token'],
        expiresIn: response['expires_in'],
      );
    } catch (exception, stackTrace) {
      print('RefreshResponse parsing ERROR: $exception');
      print(stackTrace);
      return const RefreshResponse.error();
    }
  }
}
