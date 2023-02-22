import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/sended_comment.dart';


@immutable
class SendedCommentResponse {
  final SendedComment sendedComment;

  const SendedCommentResponse.success({@required this.sendedComment});
  const SendedCommentResponse.error() : sendedComment = null;

  factory SendedCommentResponse.fromResponse( Response response) {
    try {
     // log('SendedComment response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return SendedCommentResponse.success(
        sendedComment: SendedComment.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('SendedComment parsing ERROR: $exception');
      print(stackTrace);
      return const SendedCommentResponse.error();
    }
  }
}