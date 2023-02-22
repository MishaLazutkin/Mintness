
class Tasklists {
  Tasklists({
    this.status,
    this.lists,
  });

  String status;
  List<ListElement> lists;

  factory Tasklists.fromJson(Map<String, dynamic> json) => Tasklists(
    status: json["status"],
    lists: List<ListElement>.from(json["lists"].map((x) => ListElement.fromJson(x))),
  );

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

}
