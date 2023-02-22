import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/create_subtask.dart';
import 'package:mintness/models/domain/priorities.dart';
import 'package:mintness/utils/methods.dart';


@immutable
class CreateSubtaskResponse {
  final CreateSubtask createSubtask;

  const CreateSubtaskResponse.success({@required this.createSubtask});
  const CreateSubtaskResponse.error() : createSubtask = null;

  factory CreateSubtaskResponse.fromResponse( Response response) {
    try {
      log('CreateSubtaskResponse response.body ${response.data}');
      toast('${response?.data['message']??'Error'}',
          type: getType(response?.data['status']??null));

      final decoded =  response.data  as Map<String, dynamic>;
      return CreateSubtaskResponse.success(
        createSubtask: CreateSubtask.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('BaseResponse parsing ERROR: $exception');
      print(stackTrace);
      return const CreateSubtaskResponse.error();
    }
  }
}