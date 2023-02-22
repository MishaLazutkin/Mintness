
class TimeSheetRsp {
  TimeSheetRsp({
    this.status,
    this.timesheet,
  });

  String status;
  Timesheet timesheet;

  factory TimeSheetRsp.fromJson(Map<String, dynamic> json) => TimeSheetRsp(
    status: json["status"],
    timesheet: Timesheet.fromJson(json["timesheet"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "timesheet": timesheet.toJson(),
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
    this.timesheetFormattedDuration,
    this.date,
    this.formattedDuration,
    this.project,
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
  String end;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int duration;
  String timesheetFormattedDuration;
  String date;
  String formattedDuration;
  Project project;
  Task task;
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
    timesheetFormattedDuration: json["formatted_duration"],
    date: json["date"],
    formattedDuration: json["formattedDuration"],
    project: Project.fromJson(json["project"]),
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
    "formatted_duration": timesheetFormattedDuration,
    "date": date,
    "formattedDuration": formattedDuration,
    "project": project.toJson(),
    "task": task.toJson(),
    "user": user.toJson(),
  };
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
    this.deadline,
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
  String startDate;
  String endDate;
  dynamic completedAt;
  Deadline deadline;

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
    startDate: json["start_date"],
    endDate: json["end_date"],
    completedAt: json["completed_at"],
    deadline: Deadline.fromJson(json["deadline"]),
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