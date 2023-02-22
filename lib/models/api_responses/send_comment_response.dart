import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/send_comment.dart';


@immutable
class SendCommentResponse {
  final SendComment sendComment;

  const SendCommentResponse.success({@required this.sendComment});
  const SendCommentResponse.error() : sendComment = null;

  factory SendCommentResponse.fromResponse(Response response) {
    try {
     // log('Task response.body ${response.body}');
      final decoded =  response.data  as Map<String, dynamic>;
      return SendCommentResponse.success(
        sendComment: SendComment.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Comments parsing ERROR: $exception');
      print(stackTrace);
      return const SendCommentResponse.error();
    }
  }
}