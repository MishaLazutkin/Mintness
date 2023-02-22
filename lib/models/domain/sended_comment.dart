
class SendedComment {
  SendedComment({
    this.status,
    this.message,
    this.comment,
  });

  String status;
  String message;
  Comment comment;

  factory SendedComment.fromJson(Map<String, dynamic> json) => SendedComment(
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
    this.taskId,
    this.text,
    this.userId,
    this.createdAt,
    this.id,
    this.user,
    this.files,
  });

  String taskId;
  String text;
  int userId;
  String createdAt;
  int id;
  User user;
  List<dynamic> files;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    taskId: json["task_id"],
    text: json["text"],
    userId: json["user_id"],
    createdAt: json["created_at"],
    id: json["id"],
    user: User.fromJson(json["user"]),
    files: List<dynamic>.from(json["files"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "text": text,
    "user_id": userId,
    "created_at": createdAt,
    "id": id,
    "user": user.toJson(),
    "files": List<dynamic>.from(files.map((x) => x)),
  };
}

class User {
  User({
    this.id,
    this.email,
    this.name,
    this.roleId,
    this.department,
    this.position,
    this.priceRate,
    this.dayoffRate,
    this.workdayLength,
    this.workdays,
    this.hr,
    this.dh,
    this.statusId,
    this.dob,
    this.phone,
    this.location,
    this.timezone,
    this.avatar,
    this.isBlocked,
    this.activity,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  int id;
  String email;
  String name;
  int roleId;
  String department;
  String position;
  int priceRate;
  int dayoffRate;
  String workdayLength;
  List<dynamic> workdays;
  bool hr;
  bool dh;
  int statusId;
  String dob;
  String phone;
  dynamic location;
  String timezone;
  String avatar;
  bool isBlocked;
  dynamic activity;
  dynamic deletedAt;
  String createdAt;
  DateTime updatedAt;
  Status status;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    roleId: json["role_id"],
    department: json["department"],
    position: json["position"],
    priceRate: json["price_rate"],
    dayoffRate: json["dayoff_rate"],
    workdayLength: json["workday_length"],
    workdays: List<dynamic>.from(json["workdays"].map((x) => x)),
    hr: json["hr"],
    dh: json["dh"],
    statusId: json["status_id"],
    dob: json["dob"],
    phone: json["phone"],
    location: json["location"],
    timezone: json["timezone"],
    avatar: json["avatar"],
    isBlocked: json["is_blocked"],
    activity: json["activity"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
    status: Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "role_id": roleId,
    "department": department,
    "position": position,
    "price_rate": priceRate,
    "dayoff_rate": dayoffRate,
    "workday_length": workdayLength,
    "workdays": List<dynamic>.from(workdays.map((x) => x)),
    "hr": hr,
    "dh": dh,
    "status_id": statusId,
    "dob": dob,
    "phone": phone,
    "location": location,
    "timezone": timezone,
    "avatar": avatar,
    "is_blocked": isBlocked,
    "activity": activity,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
    "status": status,
  };
}

class Status {
  Status({
    this.id,
    this.name,
    this.color,
    this.order,
  });

  int id;
  String name;
  String color;
  int order;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    name: json["name"],
    color: json["color"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color": color,
    "order": order,
  };
}