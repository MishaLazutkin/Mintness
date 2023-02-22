import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/current_timer.dart';


@immutable
class CurrentTimerResponse {
  final CurrentTimer currentTimerResponse;

  const CurrentTimerResponse.success({@required this.currentTimerResponse});
  const CurrentTimerResponse.error() : currentTimerResponse = null;

  factory CurrentTimerResponse.fromResponse( Response response) {
    try {
     // log('CurrentTimerResponse ${response.body}');
      final decoded =  response.data as Map<String, dynamic>;
      return CurrentTimerResponse.success(
        currentTimerResponse: CurrentTimer.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('CurrentTimer parsing ERROR: $exception');
      print(stackTrace);
      return const CurrentTimerResponse.error();
    }
  }
}