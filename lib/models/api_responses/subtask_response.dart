
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/recent_tasks.dart';
import 'package:mintness/models/domain/subtask_by_id.dart';


@immutable
class SubTaskResponse {
  final SubTaskById subTaskById;

  const SubTaskResponse.success({@required this.subTaskById});
  const SubTaskResponse.error() : subTaskById = null;

  factory SubTaskResponse.fromResponse(Response response) {
    try {
       //log('SubTaskById response  ${response.data}');
      final decoded =  response.data as Map<String, dynamic>;
      return SubTaskResponse.success(
        subTaskById: SubTaskById.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('SubTaskById parsing ERROR: $exception');
      print(stackTrace);
      return const SubTaskResponse.error();
    }
  }
}