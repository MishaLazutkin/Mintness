

class SendComment {
  SendComment({
    this.status,
    this.message,
    this.comment,
  });

  String status;
  String message;
  Comment comment;

  factory SendComment.fromJson(Map<String, dynamic> json) => SendComment(
    status: json["status"],
    message: json["message"],
    comment: Comment.fromJson(json["comment"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "comment": comment.toJson(),
  };
}

class Comment {
  Comment({
    this.relationType,
    this.relationId,
    this.userId,
    this.subject,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.user,
  });

  String relationType;
  String relationId;
  int userId;
  String subject;
  String description;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  User user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    relationType: json["relation_type"],
    relationId: json["relation_id"],
    userId: json["user_id"],
    subject: json["subject"],
    description: json["description"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "relation_type": relationType,
    "relation_id": relationId,
    "user_id": userId,
    "subject": subject,
    "description": description,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "user": user.toJson(),
  };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.avatar,
    this.fullName,
    this.shortFullName,
  });

  int id;
  String firstName;
  String lastName;
  String avatar;
  String fullName;
  String shortFullName;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
    fullName: json["full_name"],
    shortFullName: json["short_full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
    "full_name": fullName,
    "short_full_name": shortFullName,
  };
}
