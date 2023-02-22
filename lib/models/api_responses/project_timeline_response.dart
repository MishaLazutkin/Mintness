import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/project_timeline.dart';


@immutable
class ProjectTimelineResponse {
  final ProjectTimeline timeline;

  const ProjectTimelineResponse.success({@required this.timeline});
  const ProjectTimelineResponse.error() : timeline = null;

  factory ProjectTimelineResponse.fromResponse( Response response) {
    try {
    //  log('ProjectTimelineResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return ProjectTimelineResponse.success(
        timeline: ProjectTimeline.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ProjectTimeline parsing ERROR: $exception');
      print(stackTrace);
      return const ProjectTimelineResponse.error();
    }
  }
}