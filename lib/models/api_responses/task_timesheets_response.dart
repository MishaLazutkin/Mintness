import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/task_timesheets.dart';


@immutable
class TaskTimesheetsResponse {
  final TaskTimesheets taskTimesheets;

  const TaskTimesheetsResponse.success({@required this.taskTimesheets});
  const TaskTimesheetsResponse.error() : taskTimesheets = null;

  factory TaskTimesheetsResponse.fromResponse( Response response) {
    try {
      //log('TaskTimesheetsResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return TaskTimesheetsResponse.success(
        taskTimesheets: TaskTimesheets.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('TaskTimesheetsResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TaskTimesheetsResponse.error();
    }
  }
}