import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/comments.dart';


@immutable
class CommentsResponse {
  final Comments comments;

  const CommentsResponse.success({@required this.comments});
  const CommentsResponse.error() : comments = null;

  factory CommentsResponse.fromResponse( Response response) {
    try {
      //log('CommentsResponse response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return CommentsResponse.success(
        comments: Comments.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('CommentsResponse parsing ERROR: $exception');
      print(stackTrace);
      return const CommentsResponse.error();
    }
  }
}