
class Priorities {
  Priorities({
    this.priorities,
  });

  List<Priority> priorities;

  factory Priorities.fromJson(Map<String, dynamic> json) => Priorities(
    priorities: List<Priority>.from(json["priorities"].map((x) => Priority.fromJson(x))),
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
