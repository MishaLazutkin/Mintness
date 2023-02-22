
class UpdateProject {
  UpdateProject({
    this.project,
    this.status,
    this.message,
  });

  Project project;
  String status;
  String message;

  factory UpdateProject.fromJson(Map<String, dynamic> json) => UpdateProject(
    project: Project.fromJson(json["project"]),
    status: json["status"],
    message: json["message"],
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
  Priority priority;
  Status status;
  List<dynamic> users;

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
    priority: Priority.fromJson(json["priority"]),
    status: Status.fromJson(json["status"]),
    users: List<dynamic>.from(json["users"].map((x) => x)),
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

}
