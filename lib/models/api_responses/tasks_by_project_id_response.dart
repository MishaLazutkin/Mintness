
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/tasks_by_project_id.dart';


@immutable
class TasksByProjectIdResponse {
  final TasksByProjectId tasksByProjectId;
  const TasksByProjectIdResponse.success({@required this.tasksByProjectId});
  const TasksByProjectIdResponse.error() : tasksByProjectId = null;
  factory TasksByProjectIdResponse.fromResponse( Response response) {
    try {
      final decoded =  response.data as Map<String, dynamic>;
      return TasksByProjectIdResponse.success(
        tasksByProjectId: TasksByProjectId.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('TasksByProjectIdResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TasksByProjectIdResponse.error();
    }
  }
}
