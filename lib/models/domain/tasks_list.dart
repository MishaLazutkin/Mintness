
class ProjectTaskList {
  ProjectTaskList({
    this.status,
    this.lists,
  });

  String status;
  List<ListElement> lists;

  factory ProjectTaskList.fromJson(Map<String, dynamic> json) => ProjectTaskList(
    status: json["status"],
    lists: List<ListElement>.from(json["lists"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "lists": List<dynamic>.from(lists.map((x) => x.toJson())),
  };
}

class ListElement {
  ListElement({
    this.id,
    this.projectId,
    this.name,
    this.color,
  });

  int id;
  int projectId;
  String name;
  String color;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    projectId: json["project_id"],
    name: json["name"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_id": projectId,
    "name": name,
    "color": color,
  };
}
