import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:mintness/models/domain/tasks.dart';


@immutable
class TasksResponse {
  final Tasks tasks;

  const TasksResponse.success({@required this.tasks});
  const TasksResponse.error() : tasks = null;

  factory TasksResponse.fromResponse( Response response) {
    try {
     // log('response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return TasksResponse.success(
        tasks: Tasks.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ProjectsResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TasksResponse.error();
    }
  }
}