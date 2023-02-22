import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/project.dart';


@immutable
class ProjectResponse {
  final Project project;
  const ProjectResponse.success({@required this.project});
  const ProjectResponse.error() : project = null;
  factory ProjectResponse.fromResponse( Response response) {
    try {
      final decoded =  response.data  as Map<String, dynamic>;
      print('decoded response ${decoded.toString()}');
      return ProjectResponse.success(
        project: Project.fromJson(decoded['project']),
      );
    } catch (exception, stackTrace) {
      print('ProjectResponse parsing ERROR: $exception');
      print(stackTrace);
      return const ProjectResponse.error();
    }
  }
}
