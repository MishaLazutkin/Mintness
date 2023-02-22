

class CurrentTimer {
  CurrentTimer({
    this.status,
    this.timer,
  });

  String status;
  Timer timer;

  factory CurrentTimer.fromJson(Map<String, dynamic> json) {
    return CurrentTimer(
      status: json["status"],
      timer: Timer.fromJson(json["timer"]),
    );
  }
}

class Timer {
  Timer({
    this.id,
    this.projectId,
    this.taskId,
    this.userId,
    this.isManual,
    this.from,
    this.to,
    this.description,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.diff,
    this.task,
    this.user,
  });

  int id;
  int projectId;
  int taskId;
  int userId;
  int isManual;
  DateTime from;
  dynamic to;
  String description;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  Map<String, dynamic> diff;
  Task task;
  User user;

  factory Timer.fromJson(Map<String, dynamic> json) {
    if(json==null) return null;

   return   Timer(
        id: json["id"],
        projectId: json["project_id"],
        taskId: json["task_id"],
        userId: json["user_id"],
        isManual: json["is_manual"],
        from: DateTime.parse(json["from"]),
        to: json["to"],
        description: json["description"],
        deletedAt: json["deleted_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        diff: Map.from(json["diff"]).map((k, v) =>
            MapEntry<String, double>(k, v.toDouble())),
        task: Task.fromJson(json["task"]),
        user: User.fromJson(json["user"]),
      );


}

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_id": projectId,
    "task_id": taskId,
    "user_id": userId,
    "is_manual": isManual,
    "from": from.toIso8601String(),
    "to": to,
    "description": description,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "diff": Map.from(diff).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "task": task.toJson(),
    "user": user.toJson(),
  };
}

class Task {
  Task({
    this.id,
    this.projectId,
    this.name,
    this.project,
  });

  int id;
  int projectId;
  String name;
  Project project;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    projectId: json["project_id"],
    name: json["name"],
    project: Project.fromJson(json["project"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_id": projectId,
    "name": name,
    "project": project.toJson(),
  };
}

class Project {
  Project({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.shortFullName,
  });

  int id;
  String firstName;
  String lastName;
  String fullName;
  String shortFullName;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    fullName: json["full_name"],
    shortFullName: json["short_full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "short_full_name": shortFullName,
  };
}
