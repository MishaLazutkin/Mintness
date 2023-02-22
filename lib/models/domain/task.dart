
class TaskClass {
  TaskClass({
    this.status,
    this.task,
  });
  String status;
  Task task;

  factory TaskClass.fromJson(Map<String, dynamic> json) => TaskClass(
    status: json["status"],
    task: Task.fromJson(json["task"]),
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
    this.isEditable,
    this.project,
    this.comments,
    this.subtasks,
    this.users,
    this.taskList,
    this.status,
    this.priority,
    this.files,
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
  bool isEditable;
  Project project;
  List<Comment> comments;
  List<Subtask> subtasks;
  List<User> users;
  Status taskList;
  Status status;
  Priority priority;
  List<dynamic> files;

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
    isEditable: json["is_editable"],
    project: Project.fromJson(json["project"]),
    comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
    subtasks: List<Subtask>.from(json["subtasks"].map((x) => Subtask.fromJson(x))),
    users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
    taskList: Status.fromJson(json["task_list"]),
    status: Status.fromJson(json["status"]),
    priority: Priority.fromJson(json["priority"]),
    files: List<dynamic>.from(json["files"].map((x) => x)),
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
    //"deadline": deadline.toJson(),
    "is_editable": isEditable,
    //"project": project.toJson(),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    //"subtasks": List<dynamic>.from(subtasks.map((x) => x.toJson())),
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    //"task_list": taskList.toJson(),
    //"status": status.toJson(),
    //"priority": priority.toJson(),
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    this.id,
    this.taskId,
    this.userId,
    this.text,
    this.createdAt,
    this.isAuthor,
    this.user,
    this.files,
  });

  int id;
  int taskId;
  int userId;
  String text;
  String createdAt;
  bool isAuthor;
  UserComment user;
  List<dynamic> files;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    taskId: json["task_id"],
    userId: json["user_id"],
    text: json["text"],
    createdAt: json["created_at"],
    isAuthor: json["is_author"],
    user: UserComment.fromJson(json["user"]),
    files: List<dynamic>.from(json["files"].map((x) => x)),
  );

}

class UserComment {
  UserComment({
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
  UserStatus status;

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
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
    status: UserStatus.fromJson(json["status"]),
  );

}
class UserStatus {
  UserStatus({
    this.id,
    this.name,
    this.color,
    this.order,
  });

  int id;
  String name;
  String color;
  int order;

  factory UserStatus.fromJson(Map<String, dynamic> json) => UserStatus(
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
  dynamic method;
  dynamic estimate;
  dynamic projectHours;
  dynamic price;
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
  );

}

class Status {
  Status({
    this.id,
    this.name,
    this.color,
    this.projectId,
  });

  int id;
  String name;
  String color;
  int projectId;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
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
    //this.pivot,
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
  UserStatus status;
  //FluffyPivot pivot;

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
    status: UserStatus.fromJson(json["status"]),
    //pivot: FluffyPivot.fromJson(json["pivot"]),
    //pivot: Pivot.fromJson(json["pivot"]),
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
    //"pivot": pivot.toJson(),
  };
}

class Pivot {
  Pivot({
    this.taskId,
    this.userId,
    this.milestoneId,
  });

  int taskId;
  int userId;
  int milestoneId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    taskId: json["task_id"] == null ? null : json["task_id"],
    userId: json["user_id"],
    milestoneId: json["milestone_id"] == null ? null : json["milestone_id"],
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