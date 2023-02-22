import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
abstract class ChatEvent {
  const ChatEvent();
}

abstract class UserTyping extends ChatEvent {}

class UserStartedTyping extends UserTyping {
  @override
  String toString() => "UserStartedTyping()";
}

class UserStoppedTyping extends UserTyping {
  @override
  String toString() => "UserStoppedTyping()";
}

enum ChatUserEvent { left, joined }

class ChatUser extends ChatEvent {
  final String userName;
  final ChatUserEvent userEvent;

  const ChatUser({
      this.userName,
    this.userEvent = ChatUserEvent.joined,
  });

  factory ChatUser.fromMap(Map<String, dynamic> map, {ChatUserEvent chatUserEvent}) {
    return ChatUser(
      userName: map['userName'],
      userEvent: chatUserEvent,
    );
  }

  @override
  String toString() => 'ChatUser(userName: $userName, userEvent: $userEvent)';
}

class Message extends ChatEvent {
  final String messageContent;
  final String conversationName;
  final String userName;

  const Message({
    this.messageContent,
    this.conversationName,
    this.userName,
  });

  @override
  String toString() => 'Message(conversationName: $conversationName, content: $messageContent, userName: $userName)';

  Message copyWith({
    String content,
    String conversationName,
    String userName,
  }) {
    return Message(
      messageContent: content ?? this.messageContent,
      conversationName: conversationName ?? this.conversationName,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageContent': messageContent,
      'conversationName': conversationName,
      'userName': userName,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageContent: map['messageContent'],
      conversationName: map['conversationName'],
      userName: map['userName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));
}
