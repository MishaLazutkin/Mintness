
import 'dart:convert';

List<TaskStatus> tasksProgressStatusesFromJson(List<dynamic> str) => List<TaskStatus>.from( str .map((x) => TaskStatus.fromJson(x)));

class TaskStatus {
  TaskStatus({
    this.id,
    this.name,
    this.color,
  });

  int id;
  String name;
  String color;

  factory TaskStatus.fromJson(Map<String, dynamic> json) => TaskStatus(
    id: json["id"],
    name: json["name"],
    color: json["color"],
  );

}
