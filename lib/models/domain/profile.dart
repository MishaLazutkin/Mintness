
class Profile {
  Profile({
    this.user,
    this.statusList,
  });

  User user;
  List<Status> statusList;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    user: User.fromJson(json["user"]),
    statusList: List<Status>.from(json["statusList"].map((x) => Status.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "statusList": List<dynamic>.from(statusList.map((x) => x.toJson())),
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
    label: json["label"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "label": label,
    "icon": icon,
  };
}

class Timer {
  Timer({
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
    this.task,
    this.user,
  });

  int id;
  int projectId;
  int taskId;
  dynamic subtaskId;
  int userId;
  int isManual;
  String start;
  dynamic end;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int duration;
  String formattedDuration;
  Task task;
  User user;

  factory Timer.fromJson(Map<String, dynamic> json) => Timer(
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
    task: Task.fromJson(json["task"]),
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
    "task": task.toJson(),
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
    this.timer,
    this.role,
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
  Timer timer;
  Role role;

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
    timer: json["timer"] == null ? null : Timer.fromJson(json["timer"]),
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
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
    "status": status.toJson(),
    "timer": timer == null ? null : timer.toJson(),
    "role": role == null ? null : role.toJson(),
  };
}

class Task {
  Task({
    this.id,
    this.projectId,
    this.taskListId,
    this.title,
    this.description,
    this.statusId,
    this.priorityId,
    this.taskStartDate,
    this.taskEndDate,
    this.completedAt,
    this.estimate,
    this.rate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subtasksCount,
    this.filesCount,
    this.timesheetsCount,
    this.type,
    this.startDate,
    this.endDate,
    this.formatStartDate,
    this.formatEndDate,
    this.totalTime,
    this.yourTotalTime,
    this.deadline,
  });

  int id;
  int projectId;
  int taskListId;
  String title;
  String description;
  int statusId;
  int priorityId;
  DateTime taskStartDate;
  DateTime taskEndDate;
  dynamic completedAt;
  dynamic estimate;
  dynamic rate;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int subtasksCount;
  int filesCount;
  int timesheetsCount;
  String type;
  DateTime startDate;
  DateTime endDate;
  String formatStartDate;
  String formatEndDate;
  String totalTime;
  String yourTotalTime;
  Deadline deadline;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    projectId: json["project_id"],
    taskListId: json["task_list_id"],
    title: json["title"],
    description: json["description"],
    statusId: json["status_id"],
    priorityId: json["priority_id"],
    taskStartDate: DateTime.parse(json["start_date"]),
    taskEndDate: DateTime.parse(json["end_date"]),
    completedAt: json["completed_at"],
    estimate: json["estimate"],
    rate: json["rate"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    subtasksCount: json["subtasks_count"],
    filesCount: json["files_count"],
    timesheetsCount: json["timesheets_count"],
    type: json["type"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    formatStartDate: json["format_start_date"],
    formatEndDate: json["format_end_date"],
    totalTime: json["total_time"],
    yourTotalTime: json["your_total_time"],
    deadline: Deadline.fromJson(json["deadline"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_id": projectId,
    "task_list_id": taskListId,
    "title": title,
    "description": description,
    "status_id": statusId,
    "priority_id": priorityId,
    "start_date": "${taskStartDate.year.toString().padLeft(4, '0')}-${taskStartDate.month.toString().padLeft(2, '0')}-${taskStartDate.day.toString().padLeft(2, '0')}",
    "end_date": "${taskEndDate.year.toString().padLeft(4, '0')}-${taskEndDate.month.toString().padLeft(2, '0')}-${taskEndDate.day.toString().padLeft(2, '0')}",
    "completed_at": completedAt,
    "estimate": estimate,
    "rate": rate,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "subtasks_count": subtasksCount,
    "files_count": filesCount,
    "timesheets_count": timesheetsCount,
    "type": type,
    "startDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "endDate": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "format_start_date": formatStartDate,
    "format_end_date": formatEndDate,
    "total_time": totalTime,
    "your_total_time": yourTotalTime,
    "deadline": deadline.toJson(),
  };
}

class Deadline {
  Deadline({
    this.lightDeadline,
    this.hardDeadline,
    this.expired,
    this.text,
    this.percentage,
    this.color,
  });

  bool lightDeadline;
  bool hardDeadline;
  bool expired;
  String text;
  int percentage;
  String color;

  factory Deadline.fromJson(Map<String, dynamic> json) => Deadline(
    lightDeadline: json["light_deadline"],
    hardDeadline: json["hard_deadline"],
    expired: json["expired"],
    text: json["text"],
    percentage: json["percentage"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "light_deadline": lightDeadline,
    "hard_deadline": hardDeadline,
    "expired": expired,
    "text": text,
    "percentage": percentage,
    "color": color,
  };
}

class Role {
  Role({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
