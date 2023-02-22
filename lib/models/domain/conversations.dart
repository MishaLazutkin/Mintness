
class Conversations {
  Conversations({
    this.status,
    this.conversations,
  });

  String status;
  List<Conversation> conversations;

  factory Conversations.fromJson(Map<String, dynamic> json) => Conversations(
    status: json["status"],
    conversations: List<Conversation>.from(json["conversations"].map((x) => Conversation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "conversations": List<dynamic>.from(conversations.map((x) => x.toJson())),
  };
}

class Conversation {
  Conversation({
    this.id,
    this.type,
    this.name,
    this.description,
    this.avatar,
    this.userId,
    this.lastMessageId,
    this.fixedMessageId,
    this.count,
    this.createdAt,
    this.unreadMessagesCount,
    this.firstUnreadMessageOffset,
    this.isOwner,
    this.isManager,
    this.isPinned,
    this.notifications,
    this.users,
    this.lastMessage,
  });

  int id;
  String type;
  String name;
  String description;
  dynamic avatar;
  int userId;
  dynamic lastMessageId;
  dynamic fixedMessageId;
  int count;
  DateTime createdAt;
  int unreadMessagesCount;
  dynamic firstUnreadMessageOffset;
  bool isOwner;
  bool isManager;
  bool isPinned;
  bool notifications;
  List<User> users;
  dynamic lastMessage;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    description: json["description"],
    avatar: json["avatar"],
    userId: json["user_id"],
    lastMessageId: json["last_message_id"],
    fixedMessageId: json["fixed_message_id"],
    count: json["count"],
    createdAt: DateTime.parse(json["created_at"]),
    unreadMessagesCount: json["unread_messages_count"],
    firstUnreadMessageOffset: json["first_unread_message_offset"],
    isOwner: json["is_owner"],
    isManager: json["is_manager"],
    isPinned: json["is_pinned"],
    notifications: json["notifications"],
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    lastMessage: json["last_message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "description": description,
    "avatar": avatar,
    "user_id": userId,
    "last_message_id": lastMessageId,
    "fixed_message_id": fixedMessageId,
    "count": count,
    "created_at": createdAt.toIso8601String(),
    "unread_messages_count": unreadMessagesCount,
    "first_unread_message_offset": firstUnreadMessageOffset,
    "is_owner": isOwner,
    "is_manager": isManager,
    "is_pinned": isPinned,
    "notifications": notifications,
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "last_message": lastMessage,
  };
}

class User {
  User({
    this.id,
    this.avatar,
    this.name,
    this.email,
    this.department,
    this.position,
    this.phone,
    this.timezone,
    this.status,
    this.pivot,
  });

  int id;
  String avatar;
  String name;
  String email;
  String department;
  String position;
  String phone;
  String timezone;
  Status status;
  Pivot pivot;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    name: json["name"],
    email: json["email"],
    department: json["department"] == null ? null :  json["department"] ,
    position: json["position"] == null ? null :  json["position"] ,
    phone: json["phone"],
    timezone:  json["timezone"] ,
    status: Status.fromJson(json["status"]),
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar == null ? null : avatar,
    "name": name,
    "email": email,
    "department": department == null ? null :  department ,
    "position": position == null ? null : position ,
    "phone": phone,
    "timezone":  timezone ,
    "status": status.toJson(),
    "pivot": pivot.toJson(),
  };
}


class Pivot {
  Pivot({
    this.conversationId,
    this.userId,
    this.unread,
    this.firstUnreadOffset,
    this.pinned,
    this.notifications,
    this.isManager,
  });

  int conversationId;
  int userId;
  int unread;
  dynamic firstUnreadOffset;
  int pinned;
  int notifications;
  int isManager;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    conversationId: json["conversation_id"],
    userId: json["user_id"],
    unread: json["unread"],
    firstUnreadOffset: json["first_unread_offset"],
    pinned: json["pinned"],
    notifications: json["notifications"],
    isManager: json["is_manager"],
  );

  Map<String, dynamic> toJson() => {
    "conversation_id": conversationId,
    "user_id": userId,
    "unread": unread,
    "first_unread_offset": firstUnreadOffset,
    "pinned": pinned,
    "notifications": notifications,
    "is_manager": isManager,
  };
}

class Status {
  Status({
    this.id,
    this.value,
    this.label,
    this.icon,
  });

  int id;
  int value;
  String label;
  String icon;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    value: json["value"],
    label:  json["label"] ,
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "label":  label ,
    "icon": icon,
  };
}


