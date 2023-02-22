import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';


@immutable
class UpdateProfileResponse {
  final BaseResponse updateProfile;

  const UpdateProfileResponse.success({@required this.updateProfile});
  const UpdateProfileResponse.error() : updateProfile = null;

  factory UpdateProfileResponse.fromResponse( Response response) {
    try {
      log('UpdateProfileResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return UpdateProfileResponse.success(
        updateProfile: BaseResponse.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('UpdateProfileResponse parsing ERROR: $exception');
      print(stackTrace);
      return const UpdateProfileResponse.error();
    }
  }
}