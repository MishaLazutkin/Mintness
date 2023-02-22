import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/update_project.dart';
import 'package:mintness/utils/methods.dart';


@immutable
class UpdateProjectResponse {
  final UpdateProject updateProject;

  const UpdateProjectResponse.success({@required this.updateProject});
  const UpdateProjectResponse.error() : updateProject = null;

  factory UpdateProjectResponse.fromResponse( Response response) {
    try {
      //log('UpdateProject response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      toast(response.data['message'], type: getType(response.data['status']));
      return UpdateProjectResponse.success(
        updateProject: UpdateProject.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('UpdateProject parsing ERROR: $exception');
      print(stackTrace);
      return const UpdateProjectResponse.error();
    }
  }
}