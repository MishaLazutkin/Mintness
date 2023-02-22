import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/profile.dart';


@immutable
class ProfileResponse {
  final Profile profile;

  const ProfileResponse.success({@required this.profile});
  const ProfileResponse.error() : profile = null;

  factory ProfileResponse.fromResponse( Response response) {
    try {
      final decoded =  response.data  as Map<String, dynamic>;
      //log('profile response ${decoded.toString()}');
      return ProfileResponse.success(
        profile: Profile.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ProfileResponse parsing ERROR: $exception');
      print(stackTrace);
      return const ProfileResponse.error();
    }
  }
}
