
class Comments {
  Comments({
    this.status,
    this.comments,
  });

  String status;
  List<Comment> comments;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
    status: json["status"],
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    this.id,
    this.taskId,
    this.userId,
    this.text,
    this.createdAt,
    this.user,
    this.files,
  });

  int id;
  int taskId;
  int userId;
  String text;
  String createdAt;
  User user;
  List<FileElement> files;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    taskId: json["task_id"],
    userId: json["user_id"],
    text: json["text"] == null ? null : json["text"],
    createdAt: json["created_at"],
    user: User.fromJson(json["user"]),
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "task_id": taskId,
    "user_id": userId,
    "text": text == null ? null : text,
    "created_at": createdAt,
    "user": user.toJson(),
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}

class FileElement {
  FileElement({
    this.id,
    this.userId,
    this.name,
    this.link,
    this.thumbnailLink,
    this.size,
    this.mimeType,
    this.baseName,
    this.friendlySize,
  });

  int id;
  int userId;
  String name;
  String link;
  String thumbnailLink;
  int size;
  String mimeType;
  String baseName;
  String friendlySize;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    link: json["link"],
    thumbnailLink: json["thumbnail_link"],
    size: json["size"],
    mimeType: json["mime_type"],
    baseName: json["base_name"],
    friendlySize: json["friendly_size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "link": link,
    "thumbnail_link": thumbnailLink,
    "size": size,
    "mime_type": mimeType,
    "base_name": baseName,
    "friendly_size": friendlySize,
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
    avatar: json["avatar"] == null ? null : json["avatar"],
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
    "avatar": avatar == null ? null : avatar,
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