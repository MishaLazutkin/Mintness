import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/ProjectsStatuses.dart';
import 'package:mintness/models/domain/base_response.dart';


@immutable
class ProjectsStatusesResponse {
  final ProjectsStatuses projectStatuses;

  const ProjectsStatusesResponse.success({@required this.projectStatuses});
  const ProjectsStatusesResponse.error() : projectStatuses = null;

  factory ProjectsStatusesResponse.fromResponse( Response response) {
    try {
      log('ProjectsStatuseResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return ProjectsStatusesResponse.success(
        projectStatuses: ProjectsStatuses.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ProjectsStatuseResponse parsing ERROR: $exception');
      print(stackTrace);
      return const ProjectsStatusesResponse.error();
    }
  }
}