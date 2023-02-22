
class TasksByProjectId {
  TasksByProjectId({
    this.status,
    this.tasks,
  });

  String status;
  List<Task> tasks;

  factory TasksByProjectId.fromJson(Map<String, dynamic> json) => TasksByProjectId(
    status: json["status"],
    tasks: List<Task>.from(json["tasks"].map((x) => Task.fromJson(x))),
  );

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
    this.project,
    this.users,
    this.taskList,
    this.status,
    this.priority,
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
  int estimate;
  int rate;
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
  Project project;
  List<User> users;
  StatusClass taskList;
  StatusClass status;
  Priority priority;

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
    estimate: json["estimate"] == null ? null : json["estimate"],
    rate: json["rate"] == null ? null : json["rate"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    subtasksCount: json["subtasks_count"],
    filesCount: json["files_count"],
    timesheetsCount: json["timesheets_count"],
    type:  json["type" ],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    formatStartDate:  json["format_start_date"] ,
    formatEndDate: json["format_end_date"],
    totalTime:  json["total_time"] ,
    yourTotalTime:  json["your_total_time" ],
    project: Project.fromJson(json["project"]),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    taskList: StatusClass.fromJson(json["task_list"]),
    status: StatusClass.fromJson(json["status"]),
    priority: Priority.fromJson(json["priority"]),
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

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    statusId: json["status_id"],
    priorityId: json["priority_id"],
    name:  json["name"] ,
    description: json["description"],
    type:  json["type"] ,
    client:  json["client"] ,
    method:  json["method" ],
    estimate: json["estimate"],
    projectHours: json["project_hours"],
    price: json["price"],
    public: json["public"],
    alert: json["alert"],
    notifications: List<int>.from(json["notifications"].map((x) => x)),
    startDate:  json["start_date" ],
    endDate:  json["end_date" ],
    completedAt: json["completed_at"],
  );

}


class StatusClass {
  StatusClass({
    this.id,
    this.name,
    this.color,
    this.projectId,
  });

  int id;
  String name;
  String color;
  int projectId;

  factory StatusClass.fromJson(Map<String, dynamic> json) => StatusClass(
    id: json["id"],
    name: json["name"],
    color: json["color"],
    projectId: json["project_id"] == null ? null : json["project_id"],
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
    department:  json["department" ],
    position:  json["position" ],
    priceRate: json["price_rate"],
    dayoffRate: json["dayoff_rate"],
    workdayLength:  json["workday_length" ],
    workdays: List<dynamic>.from(json["workdays"].map((x) => x)),
    hr: json["hr"],
    dh: json["dh"],
    statusId: json["status_id"],
    dob: json["dob"],
    phone: json["phone"],
    location: json["location"],
    timezone:  json["timezone"] ,
    avatar: json["avatar"],
    isBlocked: json["is_blocked"],
    activity: json["activity"],
    deletedAt: json["deleted_at"],
    createdAt:  json["created_at"] ,
    updatedAt: DateTime.parse(json["updated_at"]),
    status: Status.fromJson(json["status"])  ,
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
    this.taskId,
    this.userId,
  });

  int taskId;
  int userId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    taskId: json["task_id"],
    userId: json["user_id"],
  );

}

