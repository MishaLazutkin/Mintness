import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/projects_types.dart';
import 'package:mintness/models/domain/send_comment.dart';


@immutable
class ProjectsTypesResponse {
  final ProjectsTypes projectsTypes;

  const ProjectsTypesResponse.success({@required this.projectsTypes});
  const ProjectsTypesResponse.error() : projectsTypes = null;

  factory ProjectsTypesResponse.fromResponse(Response response) {
    try {
      final decoded =  response.data  as Map<String, dynamic>;
      return ProjectsTypesResponse.success(
        projectsTypes: ProjectsTypes.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Comments parsing ERROR: $exception');
      print(stackTrace);
      return const ProjectsTypesResponse.error();
    }
  }
}