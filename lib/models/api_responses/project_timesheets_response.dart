import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/project_timesheets.dart';


@immutable
class ProjectTimesheetsResponse {
  final ProjectTimesheets projectTimesheets;
  const ProjectTimesheetsResponse.success({@required this.projectTimesheets});
  const ProjectTimesheetsResponse.error() : projectTimesheets = null;
  factory ProjectTimesheetsResponse.fromResponse(Response response) {


    try {
      final decoded =  response.data  as Map<String, dynamic>;
      return ProjectTimesheetsResponse.success(
        projectTimesheets: ProjectTimesheets.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ProjectTimesheetsResponse parsing ERROR: $exception');
      print(stackTrace);
      return const ProjectTimesheetsResponse.error();
    }
  }
}
