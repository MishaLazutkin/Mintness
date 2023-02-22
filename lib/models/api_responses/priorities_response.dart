import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/priorities.dart';


@immutable
class PrioritiesResponse {
  final Priorities priorities;

  const PrioritiesResponse.success({@required this.priorities});
  const PrioritiesResponse.error() : priorities = null;

  factory PrioritiesResponse.fromResponse( Response response) {
    try {
      //log('PrioritiesResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return PrioritiesResponse.success(
        priorities: Priorities.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('PrioritiesResponse parsing ERROR: $exception');
      print(stackTrace);
      return const PrioritiesResponse.error();
    }
  }
}