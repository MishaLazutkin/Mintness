import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/users_of_project.dart';


@immutable
class UsersByProjectIdResponse {
  final UsersByProjectId users;

  const UsersByProjectIdResponse.success({@required this.users});
  const UsersByProjectIdResponse.error() : users = null;

  factory UsersByProjectIdResponse.fromResponse(Response response) {
    try {
      final decoded =  response.data as Map<String, dynamic>;
      //log('decoded ${decoded.toString()}');
      return UsersByProjectIdResponse.success(
        users: UsersByProjectId.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('UsersResponse parsing ERROR: $exception');
      print(stackTrace);
      return const UsersByProjectIdResponse.error();
    }
  }
}
