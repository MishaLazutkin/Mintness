import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/create_task.dart';


@immutable
class CreateTaskResponse {
  final CreateTask createTask;

  const CreateTaskResponse.success({@required this.createTask});
  const CreateTaskResponse.error() : createTask = null;

  factory CreateTaskResponse.fromResponse( Response response) {
    try {
      log('CreateTaskResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return CreateTaskResponse.success(
        createTask: CreateTask.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('CreateTaskResponse parsing ERROR: $exception');
      print(stackTrace);
      return const CreateTaskResponse.error();
    }
  }
}