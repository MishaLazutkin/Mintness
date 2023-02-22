import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Subscription {
  final String conversationName;
  final String userName;
  Subscription({
      this.conversationName,
      this.userName,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationName': conversationName,
      'userName': userName,
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      conversationName: map['conversationName'],
      userName: map['userName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Subscription.fromJson(String source) => Subscription.fromMap(json.decode(source));

  @override
  String toString() => 'Subscription(conversationName: $conversationName, userName: $userName)';
}
