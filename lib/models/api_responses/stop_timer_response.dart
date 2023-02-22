import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';



@immutable
class StopTimerResponse {
  final  BaseResponse baseIowise;

  const StopTimerResponse.success({@required this.baseIowise});
  const StopTimerResponse.error() : baseIowise = null;

  factory StopTimerResponse.fromResponse(Response response) {
    try {
      log('response.body ${response.data}');
      final decoded =  response.data as Map<String, dynamic>;
      return StopTimerResponse.success(
        baseIowise: BaseResponse.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('StopTimerResponse parsing ERROR: $exception');
      print(stackTrace);
      return const StopTimerResponse.error();
    }
  }
}