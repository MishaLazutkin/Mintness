

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/users.dart';


@immutable
class UsersResponse {
  final List<User> users;

  const UsersResponse.success({@required this.users});
  const UsersResponse.error() : users = null;

  factory UsersResponse.fromResponse(Response response) {
    try {
      final decoded =  userFromJson( response.data)  ;
      return UsersResponse.success(
        users: userFromJson( response.data),
      );
    } catch (exception, stackTrace) {
      print('UsersResponse parsing ERROR: $exception');
      print(stackTrace);
      return const UsersResponse.error();
    }
  }
}
