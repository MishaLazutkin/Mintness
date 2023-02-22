
class Projects {
  Projects({
    this.status,
    this.projects,
  });

  String status;
  List<Project> projects;

  factory Projects.fromJson(Map<String, dynamic> json) {
    return Projects(
      status: json["status"],
      projects: List<Project>.from(
          json["projects"].map((x) => Project.fromJson(x))),
    );

  }
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
    this.startDate,
    this.endDate,
    this.completedAt,
    this.users,
    this.priority,
    this.deadline,
    this.status,
    this.files,
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
  String startDate;
  String endDate;
  Deadline deadline;
  dynamic completedAt;
  List<User> users;
  Priority priority;
  StatusClass status;
  List<FileElement> files;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id:json.containsKey('id')? json["id"]:null,
        statusId: json.containsKey( "status_id" )?json["status_id"]:0,
        priorityId: json.containsKey( "priority_id" )?json["priority_id"]:0,
        name: json["name"],
        description: json.containsKey( "description" )?json["description"]:'',
        type: json.containsKey( "type" )?json["type"]:'',
        client: json.containsKey( "client" )?json["client"]:'',
        method: json.containsKey( "method" )   ?  json["method"]:'',
        estimate: json.containsKey( "estimate" )   ?   json["estimate"]:0,
        deadline:json.containsKey( "deadline" )   ? Deadline.fromJson(json["deadline"]):null,
        projectHours:
  json.containsKey( "project_hours" )  ?  json["project_hours"]:0,
        price: json.containsKey( "price" )  ? json["price"]:'',
        public: json.containsKey( "public" )?json["public"]:0,
        alert: json.containsKey( "alert" )?json["alert"]:0,
        startDate: json.containsKey( "start_date")?json["start_date"]:'',
        endDate: json.containsKey( "end_date" )?json["end_date"]:'',
        completedAt: json.containsKey( "completed_at" )?json["completed_at"]:'',
        users:json.containsKey( "users")? List<User>.from(json["users"].map((x) => User.fromJson(x))):[],
        priority:json.containsKey( "priority" )? Priority.fromJson(json["priority"]):null,
        status:json.containsKey( "status")? StatusClass.fromJson(json["status"]):null,
        files:json.containsKey( "files")? List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))):[],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status_id": statusId,
    "priority_id": priorityId,
    "name": name,
    "description": description,
    "type": type,
    "client": client,
    "method": method == null ? null : method,
    "estimate": estimate == null ? null : estimate,
    "project_hours": projectHours == null ? null : projectHours,
    "price": price == null ? null : price,
    "public": public,
    "alert": alert,
    "start_date": startDate,
    "end_date": endDate,
    "completed_at": completedAt,
    "deadline": deadline.toJson(),
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "priority": priority.toJson(),
    "status": status.toJson(),
    "files": List<dynamic>.from(files.map((x) => x)),
  };
}

class FileElement {
  FileElement({
    this.id,
    this.userId,
    this.name,
    this.size,
    this.mimeType,
    this.baseName,
    this.friendlySize,
  });

  int id;
  int userId;
  String name;
  int size;
  String mimeType;
  String baseName;
  String friendlySize;

  factory FileElement.fromJson(Map<String, dynamic> json) {
    return FileElement(
      id: json["id"],
      userId: json["user_id"],
      name: json["name"],
      size: json["size"],
      mimeType: json["mime_type"],
      baseName: json["base_name"],
      friendlySize: json["friendly_size"],
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

  Map<String, dynamic> toJson() => {
    "light_deadline": lightDeadline,
    "hard_deadline": hardDeadline,
    "expired": expired,
    "text": text,
    "percentage": percentage,
    "color": color,
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
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
  };
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "order": order,
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
        department: json["department"] == null ? null : json["department"],
        position: json["position"] == null ? null : json["position"],
        priceRate: json["price_rate"],
        dayoffRate: json["dayoff_rate"],
        workdayLength: json["workday_length"],
        workdays: List<dynamic>.from(json["workdays"].map((x) => x)),
        hr: json["hr"],
        dh: json["dh"],
        statusId: json["status_id"],
        dob: json["dob"],
        phone: json["phone"],
        location: json["location"] == null ? null : json["location"],
        timezone: json["timezone"],
        avatar: json["avatar"],
        isBlocked: json["is_blocked"],
        activity: json["activity"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
        status: Status.fromJson(json["status"]),
        pivot: Pivot.fromJson(json["pivot"]),
      );
  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "role_id": roleId,
    "department":  department ,
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
    "avatar": avatar,
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
