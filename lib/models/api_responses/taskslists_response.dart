import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/taskslists.dart';


@immutable
class TasklistsResponse {
  final Tasklists tasksList;

  const TasklistsResponse.success({@required this.tasksList});
  const TasklistsResponse.error() : tasksList = null;

  factory TasklistsResponse.fromResponse( Response response) {
    try {
      log('TasklistsResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return TasklistsResponse.success(
        tasksList: Tasklists.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Tasklists parsing ERROR: $exception');
      print(stackTrace);
      return const TasklistsResponse.error();
    }
  }
}