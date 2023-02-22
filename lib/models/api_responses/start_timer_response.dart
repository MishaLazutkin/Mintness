import 'dart:convert';
import 'dart:developer';


import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/utils/methods.dart';



@immutable
class StartTimerResponse {
  final  BaseResponse baseIowise;

  const StartTimerResponse.success({@required this.baseIowise});
  const StartTimerResponse.error() : baseIowise = null;

  factory StartTimerResponse.fromResponse(Response response) {
    try {
      log('response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;

      toast(response?.data['status']=='success'?'The timer has been started':'Please stop previous timer.',
          type: getType(response?.data['status']??null));

      return StartTimerResponse.success(
        baseIowise: BaseResponse.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('StartTimerResponse parsing ERROR: $exception');
      print(stackTrace);
      return const StartTimerResponse.error();
    }
  }
}