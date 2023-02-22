import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/services/flushbar_service.dart';
import 'package:mintness/utils/methods.dart';


@immutable
class UpdateTaskResponse {
  final BaseResponse updateTask;

  const UpdateTaskResponse.success({@required this.updateTask});
  const UpdateTaskResponse.error() : updateTask = null;

  factory UpdateTaskResponse.fromResponse(Response response) {
    try {
      log('UpdateTaskResponse response.body ${response.data}');
      toast(response.data['message'],type:getType(response.data['status']));
      //FlushbarService().showMessage(response.data['message']);
      final decoded =  response.data as Map<String, dynamic>;
      return UpdateTaskResponse.success(
        updateTask: BaseResponse.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('UpdateTaskResponse parsing ERROR: $exception');
      print(stackTrace);
      return const UpdateTaskResponse.error();
    }
  }
}