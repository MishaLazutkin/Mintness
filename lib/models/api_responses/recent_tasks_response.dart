
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/recent_tasks.dart';


@immutable
class RecentTasksResponse {
  final RecentTasks recentTasks;

  const RecentTasksResponse.success({@required this.recentTasks});
  const RecentTasksResponse.error() : recentTasks = null;

  factory RecentTasksResponse.fromResponse(Response response) {
    try {
      //log('RecentTasksResponse.body ${response.data}');
      final decoded =  response.data as Map<String, dynamic>;
      return RecentTasksResponse.success(
        recentTasks: RecentTasks.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('RecentTasksResponse parsing ERROR: $exception');
      print(stackTrace);
      return const RecentTasksResponse.error();
    }
  }
}