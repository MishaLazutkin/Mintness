
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/task.dart';


@immutable
class TaskResponse {
  final TaskClass task;

  const TaskResponse.success({@required this.task});
  const TaskResponse.error() : task = null;

  factory TaskResponse.fromResponse(Response response) {
    try {
       // log('Task response  ${response.data}');
      final decoded = response.data as Map<String, dynamic>;
      return TaskResponse.success(
        task: TaskClass.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Task parsing ERROR: $exception');
      print(stackTrace);
      return const TaskResponse.error();
    }
  }
}