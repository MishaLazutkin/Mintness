
class ProjectsTypes {
  ProjectsTypes({
    this.types,
  });

  List<String> types;

  factory ProjectsTypes.fromJson(Map<String, dynamic> json) => ProjectsTypes(
    types: List<String>.from(json["types"].map((x) => x)),
  );

}
