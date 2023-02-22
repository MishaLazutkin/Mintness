
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/conversation_messages.dart';


@immutable
class ConversationMessagesResponse {
  final ConversationMessages conversationMessages;

  const ConversationMessagesResponse.success({@required this.conversationMessages});
  const ConversationMessagesResponse.error() : conversationMessages = null;

  factory ConversationMessagesResponse.fromResponse( Response response) {
    try {
      log('ConversationMessages response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return ConversationMessagesResponse.success(
        conversationMessages: ConversationMessages.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ConversationMessages parsing ERROR: $exception');
      print(stackTrace);
      return const ConversationMessagesResponse.error();
    }
  }
}