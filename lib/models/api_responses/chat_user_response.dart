import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:mintness/models/domain/base_response.dart';
import 'package:mintness/models/domain/chat_user.dart';
import 'package:mintness/models/domain/file.dart';


@immutable
class ChatUserResponse {
  final ChatUser chatUser;

  const ChatUserResponse.success({@required this.chatUser});
  const ChatUserResponse.error() : chatUser = null;

  factory ChatUserResponse.fromResponse( Response response) {
    try {
      log('ChatUser response.body ${response.data}');
      final decoded =  response.data  as Map<String, dynamic>;
      return ChatUserResponse.success(
        chatUser: ChatUser.fromJson(decoded),
      );
    } catch (exception, stackTrace) {
      print('ChatUser parsing ERROR: $exception');
      print(stackTrace);
      return const ChatUserResponse.error();
    }
  }
}