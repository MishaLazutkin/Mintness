import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/timesheet.dart';

@immutable
class TimesheetResponse {
  final TimeSheetRsp timesheet;
  const TimesheetResponse.success({@required this.timesheet});
  const TimesheetResponse.error() : timesheet = null;
  factory TimesheetResponse.fromResponse(Response response) {
    try {

      final decoded =  response.data  as Map<String, dynamic>;
      return TimesheetResponse.success(
        timesheet: TimeSheetRsp.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('TimesheetResponse parsing ERROR: $exception');
      print(stackTrace);
      return const TimesheetResponse.error();
    }
  }
}