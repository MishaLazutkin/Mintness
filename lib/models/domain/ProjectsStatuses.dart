
class ProjectsStatuses {
  ProjectsStatuses({
    this.statuses,
  });

  List<Status> statuses;

  factory ProjectsStatuses.fromJson(Map<String, dynamic> json) => ProjectsStatuses(
    statuses: List<Status>.from(json["statuses"].map((x) => Status.fromJson(x))),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color':color,
      'order':order
    };
  }
  factory Status.fromJson(Map<String, dynamic> json) => Status(
    id: json["id"],
    name: json["name"],
    color: json["color"],
    order: json["order"],
  );

}
