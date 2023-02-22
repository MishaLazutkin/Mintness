import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';


@immutable
class DeleteProjectResponse {
  final BaseResponse deleteProject;

  const DeleteProjectResponse.success({@required this.deleteProject});
  const DeleteProjectResponse.error() : deleteProject = null;

  factory DeleteProjectResponse.fromResponse( Response response) {
    try {
      log('DeleteProjectResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return DeleteProjectResponse.success(
        deleteProject: BaseResponse.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('DeleteProjectResponse parsing ERROR: $exception');
      print(stackTrace);
      return const DeleteProjectResponse.error();
    }
  }
}