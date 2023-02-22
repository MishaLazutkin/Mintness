import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/timesheets.dart';

@immutable
class TimesheetsResponse {
  final Timesheets timesheets;

  const TimesheetsResponse.success({@required this.timesheets});
  const TimesheetsResponse.error() : timesheets = null;

  factory TimesheetsResponse.fromResponse( Response response) {
    try {
      //log('Timesheets response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return TimesheetsResponse.success(
        timesheets: Timesheets.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Timesheets parsing ERROR: $exception');
      print(stackTrace);
      return const TimesheetsResponse.error();
    }
  }
}