
class ConversationMessages {
  ConversationMessages({
    this.status,
    this.messages,
  });

  String status;
  List<Message> messages;

  factory ConversationMessages.fromJson(Map<String, dynamic> json) => ConversationMessages(
    status: json["status"],
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.id,
    this.conversationId,
    this.userId,
    this.replyId,
    this.forwardId,
    this.offset,
    this.read,
    this.type,
    this.content,
    this.fromNumber,
    this.toNumber,
    this.twilioSid,
    this.updated,
    this.pinned,
    this.createdAt,
    this.files,
    this.replyMessage,
  });

  int id;
  int conversationId;
  int userId;
  dynamic replyId;
  dynamic forwardId;
  int offset;
  int read;
  String type;
  String content;
  dynamic fromNumber;
  dynamic toNumber;
  dynamic twilioSid;
  int updated;
  dynamic pinned;
  String createdAt;
  List<dynamic> files;
  dynamic replyMessage;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    conversationId: json["conversation_id"],
    userId: json["user_id"],
    replyId: json["reply_id"],
    forwardId: json["forward_id"],
    offset: json["offset"],
    read: json["read"],
    type: json["type"],
    content: json["content"],
    fromNumber: json["from_number"],
    toNumber: json["to_number"],
    twilioSid: json["twilio_sid"],
    updated: json["updated"],
    pinned: json["pinned"],
    createdAt: json["created_at"],
    files: List<dynamic>.from(json["files"].map((x) => x)),
    replyMessage: json["reply_message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "conversation_id": conversationId,
    "user_id": userId,
    "reply_id": replyId,
    "forward_id": forwardId,
    "offset": offset,
    "read": read,
    "type": type,
    "content": content,
    "from_number": fromNumber,
    "to_number": toNumber,
    "twilio_sid": twilioSid,
    "updated": updated,
    "pinned": pinned,
    "created_at": createdAt,
    "files": List<dynamic>.from(files.map((x) => x)),
    "reply_message": replyMessage,
  };
}
