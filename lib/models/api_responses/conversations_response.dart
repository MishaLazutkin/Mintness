import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/conversations.dart';
import 'package:mintness/models/domain/base_response.dart';


@immutable
class ConversationsResponse {
  final Conversations conversations;

  const ConversationsResponse.success({@required this.conversations});
  const ConversationsResponse.error() : conversations = null;

  factory ConversationsResponse.fromResponse( Response response) {
    try {
      //log('Conversations response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return ConversationsResponse.success(
        conversations: Conversations.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('Conversations parsing ERROR: $exception');
      print(stackTrace);
      return const ConversationsResponse.error();
    }
  }
}