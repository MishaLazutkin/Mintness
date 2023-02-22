
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/tasks_of_project.dart';



@immutable
class TasksOfProjectResponse {
  final TasksOfProject tasks;

  const TasksOfProjectResponse.success({@required this.tasks});
  const TasksOfProjectResponse.error() : tasks = null;

  factory TasksOfProjectResponse.fromResponse( Response response) {
    try {
      final decoded = response.data as Map<String, dynamic>;
      //log('tasks of project ${decoded.toString()}');

      return TasksOfProjectResponse.success(
        tasks: TasksOfProject.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('TasksOfProjectResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TasksOfProjectResponse.error();
    }
  }
}