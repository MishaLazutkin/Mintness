import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/tasks_list.dart';


@immutable
class TaskListsResponse {
  final ProjectTaskList taskList;

  const TaskListsResponse.success({@required this.taskList});
  const TaskListsResponse.error() : taskList = null;

  factory TaskListsResponse.fromResponse(Response response) {
    try {
      log('TaskListsResponse response.body ${response.data}');
      final decoded =  response.data as Map<String, dynamic>;
      return TaskListsResponse.success(
        taskList: ProjectTaskList.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('TaskListsResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TaskListsResponse.error();
    }
  }
}