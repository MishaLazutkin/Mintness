import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';


@immutable
class AddTimeResponse {
  final BaseResponse addTime;

  const AddTimeResponse.success({@required this.addTime});
  const AddTimeResponse.error() : addTime = null;

  factory AddTimeResponse.fromResponse( Response response) {
    try {
      log('AddTimeResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return AddTimeResponse.success(
        addTime: BaseResponse.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('AddTimeResponse parsing ERROR: $exception');
      print(stackTrace);
      return const AddTimeResponse.error();
    }
  }
}