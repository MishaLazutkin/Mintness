
class CreateSubtask {
  CreateSubtask({
    this.status,
    this.message,
    this.subtask,
  });

  String status;
  String message;
  Subtask subtask;

  factory CreateSubtask.fromJson(Map<String, dynamic> json) => CreateSubtask(
    status: json["status"],
    message: json["message"],
    subtask: Subtask.fromJson(json["subtask"]),
  );

}

class Subtask {
  Subtask({
    this.id,
    this.taskId,
    this.title,
    this.priorityId,
    this.completeStatus,
    this.completeAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.usersCount,
    this.priority,
    this.users,
  });

  int id;
  int taskId;
  String title;
  int priorityId;
  int completeStatus;
  dynamic completeAt;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int usersCount;
  Priority priority;
  List<User> users;

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
    id: json["id"],
    taskId: json["task_id"],
    title: json["title"],
    priorityId: json["priority_id"],
    completeStatus: json["complete_status"],
    completeAt: json["complete_at"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    usersCount: json["users_count"],
    priority: Priority.fromJson(json["priority"]),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

}

class Priority {
  Priority({
    this.id,
    this.name,
    this.icon,
  });

  int id;
  String name;
  String icon;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
  );

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
    this.pivot,
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
  dynamic avatar;
  bool isBlocked;
  dynamic activity;
  dynamic deletedAt;
  String createdAt;
  DateTime updatedAt;
  Status status;
  Pivot pivot;

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
    status:Status.fromJson(json["status"]),
    pivot: Pivot.fromJson(json["pivot"]),
  );

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
class Pivot {
  Pivot({
    this.subtaskId,
    this.userId,
  });

  int subtaskId;
  int userId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    subtaskId: json["subtask_id"],
    userId: json["user_id"],
  );

}
