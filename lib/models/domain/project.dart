

import 'package:mintness/utils/methods.dart';

class ProjectById {
  ProjectById({
    this.status,
    this.project,
  });

  String status;
  Project project;

  factory ProjectById.fromJson(Map<String, dynamic> json) => ProjectById(
    status: json["status"],
    project: Project.fromJson(json["project"]),
  );

}

class Project {
  Project({
    this.id,
    this.statusId,
    this.priorityId,
    this.name,
    this.description,
    this.type,
    this.client,
    this.method,
    this.estimate,
    this.projectHours,
    this.price,
    this.public,
    this.alert,
    this.notifications,
    this.startDate,
    this.endDate,
    this.completedAt,
    this.priority,
    this.status,
    this.users,
  });

  int id;
  int statusId;
  int priorityId;
  String name;
  String description;
  String type;
  String client;
  String method;
  int estimate;
  int projectHours;
  String price;
  int public;
  int alert;
  List<int> notifications;
  DateTime startDate;
  DateTime endDate;
  dynamic completedAt;
  Priority priority;
  StatusClass status;
  List<User> users;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    statusId: json["status_id"],
    priorityId: json["priority_id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    client: json["client"],
    method: json["method"],
    estimate: json["estimate"],
    projectHours: json["project_hours"],
    price: json["price"],
    public: json["public"],
    alert: json["alert"],
    notifications: List<int>.from(json["notifications"].map((x) => x)),
    startDate:stringToDate(json["start_date"]),
    endDate: stringToDate(json["end_date"]),
    completedAt: json["completed_at"],
    priority: Priority.fromJson(json["priority"]),
    status: StatusClass.fromJson(json["status"]),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status_id": statusId,
    "priority_id": priorityId,
    "name": name,
    "description": description,
    "type": type,
    "client": client,
    "method": method,
    "estimate": estimate,
    "project_hours": projectHours,
    "price": price,
    "public": public,
    "alert": alert,
    "notifications": List<dynamic>.from(notifications.map((x) => x)),
    "start_date": startDate,
    "end_date": endDate,
    "completed_at": completedAt,
    // "deadline": deadline.toJson(),
    // "priority": priority.toJson(),
    // "status": status.toJson(),
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
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

class StatusClass {
  StatusClass({
    this.id,
    this.name,
    this.color,
    this.order,
  });

  int id;
  String name;
  String color;
  int order;

  factory StatusClass.fromJson(Map<String, dynamic> json) => StatusClass(
    id: json["id"],
    name: json["name"],
    color: json["color"],
    order: json["order"],
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
  String location;
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
    department:  json["department"] ,
    position:  json["position"] ,
    priceRate: json["price_rate"],
    dayoffRate: json["dayoff_rate"],
    workdayLength:  json["workday_length"] ,
    workdays: List<dynamic>.from(json["workdays"].map((x) => x)),
    hr: json["hr"],
    dh: json["dh"],
    statusId: json["status_id"],
    dob: json["dob"],
    phone: json["phone"],
    location: json["location"] == null ? null : json["location"],
    timezone:  json["timezone"] ,
    avatar: json["avatar"],
    isBlocked: json["is_blocked"],
    activity: json["activity"],
    deletedAt: json["deleted_at"],
    createdAt:  json["created_at"] ,
    updatedAt: DateTime.parse(json["updated_at"]),
    status:  Status.fromJson(json["status"]),
    pivot: Pivot.fromJson(json["pivot"]),
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "role_id": roleId,
    "department": department ,
    "position":  position ,
    "price_rate": priceRate,
    "dayoff_rate": dayoffRate,
    "workday_length":  workdayLength ,
    "workdays": List<dynamic>.from(workdays.map((x) => x)),
    "hr": hr,
    "dh": dh,
    "status_id": statusId,
    "dob": dob,
    "phone": phone,
    "location": location,
    "timezone":  timezone ,
    "avatar": avatar == null ? null : avatar,
    "is_blocked": isBlocked,
    "activity": activity,
    "deleted_at": deletedAt,
    "created_at":  createdAt ,
    "updated_at": updatedAt.toIso8601String(),
    "status":  status ,
    "pivot": pivot.toJson(),
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

class Pivot {
  Pivot({
    this.projectId,
    this.userId,
    this.isManager,
  });

  int projectId;
  int userId;
  int isManager;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    projectId: json["project_id"],
    userId: json["user_id"],
    isManager: json["is_manager"],
  );
  Map<String, dynamic> toJson() => {
    "project_id": projectId,
    "user_id": userId,
    "is_manager": isManager,
  };
}
