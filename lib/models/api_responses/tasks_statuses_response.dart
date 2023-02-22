import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/progress_statuses.dart';


@immutable
class TasksStatusesResponse {
  final List<TaskStatus> progressStatuses;

  const TasksStatusesResponse.success({@required this.progressStatuses});
  const TasksStatusesResponse.error() : progressStatuses = null;

  factory TasksStatusesResponse.fromResponse(Response response) {
    try {
      //log('TasksProgressStatusesResponse response.body ${response.data}');
      final decoded = response.data as List<dynamic>    ;//tasksProgressStatusesFromJson(response.data)
      return TasksStatusesResponse.success(
        progressStatuses: tasksProgressStatusesFromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('TasksProgressStatusesResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TasksStatusesResponse.error();
    }
  }
}