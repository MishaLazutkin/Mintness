class ProjectTimeline {
  ProjectTimeline({
    this.timeline,
  });

  List<Timeline> timeline;

  factory ProjectTimeline.fromJson(Map<String, dynamic> json) =>
      ProjectTimeline(
        timeline: List<Timeline>.from(
            json["timeline"].map((x) => Timeline.fromJson(x))),
      );
}

class Timeline {
  Timeline({
    this.id,
    this.projectId,
    this.name,
    this.color,
    this.milestonesCount,
    this.notCompleteMilestonesCount,
    this.tasksCount,
    this.notCompleteTasksCount,
    this.items,
  });

  int id;
  int projectId;
  String name;
  String color;
  int milestonesCount;
  int notCompleteMilestonesCount;
  int tasksCount;
  int notCompleteTasksCount;
  List<Item> items;

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        id: json["id"],
        projectId: json["project_id"],
        name: json["name"],
        color: json["color"],
        milestonesCount: json["milestones_count"],
        notCompleteMilestonesCount: json["not_complete_milestones_count"],
        tasksCount: json["tasks_count"],
        notCompleteTasksCount: json["not_complete_tasks_count"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );
}

class Item {
  Item({
    this.id,
    this.projectId,
    this.taskListId,
    this.title,
    this.description,
    this.statusId,
    this.priorityId,
    this.itemStartDate,
    this.itemEndDate,
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
    this.users,
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
  DateTime itemStartDate;
  DateTime itemEndDate;
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
  dynamic deadline;
  List<User> users;
  Status status;
  Priority priority;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      projectId: json["project_id"],
      taskListId: json["task_list_id"],
      title: json["title"],
      description: json["description"],
      statusId: json["status_id"],
      priorityId: json["priority_id"],
      itemStartDate:json["start_date"]!=null? DateTime.parse(json["start_date"]):null,
      itemEndDate:json["end_date"]!=null? DateTime.parse(json["end_date"]):null,
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
      deadline:  json["deadline"] ,
      users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      status:json["status"]!=null? Status.fromJson(json["status"]):null,
      priority:json["priority"]!=null? Priority.fromJson(json["priority"]):null,
    );
  }
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
    this.name,
    this.avatar,
    this.status,
    this.pivot,
  });

  int id;
  String name;
  String avatar;
  UserStatus status;
  Pivot pivot;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        status:UserStatus.fromJson(json["status"]),
        pivot: Pivot.fromJson(json["pivot"]),
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

class Status {
  Status({
    this.id,
    this.name,
    this.color,
  });

  int id;
  String name;
  String color;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"],
        name: json["name"],
        color: json["color"],
      );
}
