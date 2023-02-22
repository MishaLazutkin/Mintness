
class TaskTimesheets {
  TaskTimesheets({
    this.status,
    this.timesheets,
  });

  String status;
  List<Timesheet> timesheets;

  factory TaskTimesheets.fromJson(Map<String, dynamic> json) => TaskTimesheets(
    status: json["status"],
    timesheets: List<Timesheet>.from(json["timesheets"].map((x) => Timesheet.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "timesheets": List<dynamic>.from(timesheets.map((x) => x.toJson())),
  };
}

class Timesheet {
  Timesheet({
    this.id,
    this.projectId,
    this.taskId,
    this.subtaskId,
    this.userId,
    this.isManual,
    this.start,
    this.end,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.duration,
    this.formattedDuration,
    this.date,
    this.user,
  });

  int id;
  int projectId;
  int taskId;
  dynamic subtaskId;
  int userId;
  int isManual;
  String start;
  String end;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int duration;
  String formattedDuration;
  String date;
  User user;

  factory Timesheet.fromJson(Map<String, dynamic> json) => Timesheet(
    id: json["id"],
    projectId: json["project_id"],
    taskId: json["task_id"],
    subtaskId: json["subtask_id"],
    userId: json["user_id"],
    isManual: json["is_manual"],
    start: json["start"],
    end: json["end"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    duration: json["duration"],
    formattedDuration: json["formatted_duration"],
    date: json["date"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_id": projectId,
    "task_id": taskId,
    "subtask_id": subtaskId,
    "user_id": userId,
    "is_manual": isManual,
    "start": start,
    "end": end,
    "description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "duration": duration,
    "formatted_duration": formattedDuration,
    "date": date,
    "user": user.toJson(),
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
  dynamic avatar;
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
    department:  json["department"],
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
    timezone:  json["timezone"],
    avatar: json["avatar"],
    isBlocked: json["is_blocked"],
    activity: json["activity"],
    deletedAt: json["deleted_at"],
    createdAt:  json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
    status: Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "role_id": roleId,
    "department":  department,
    "position":  position,
    "price_rate": priceRate,
    "dayoff_rate": dayoffRate,
    "workday_length":  workdayLength,
    "workdays": List<dynamic>.from(workdays.map((x) => x)),
    "hr": hr,
    "dh": dh,
    "status_id": statusId,
    "dob": dob,
    "phone": phone,
    "location": location,
    "timezone":  timezone,
    "avatar": avatar,
    "is_blocked": isBlocked,
    "activity": activity,
    "deleted_at": deletedAt,
    "created_at":  createdAt,
    "updated_at": updatedAt.toIso8601String(),
    "status": status.toJson(),
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
    label:  json["label"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "label":  label,
    "icon": icon,
  };
}


