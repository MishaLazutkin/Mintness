import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/projects.dart';

@immutable
class ProjectsResponse {
  final Projects projects;
  const ProjectsResponse.success({@required this.projects});
  const ProjectsResponse.error() : projects = null;
  factory ProjectsResponse.fromResponse(Response response) {
    try {
      //log('response.body ${response.body}');
      final decoded =  response.data  as Map<String, dynamic>;
      return ProjectsResponse.success(
        projects: Projects.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ProjectsResponse parsing ERROR: $exception');
      print(stackTrace);
      return const ProjectsResponse.error();
    }
  }
}