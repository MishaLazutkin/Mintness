
class Files {
  Files({
    this.files,
  });

  List<FileElement> files;

  factory Files.fromJson(Map<String, dynamic> json) => Files(
    files: List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "files": List<dynamic>.from(files.map((x) => x.toJson())),
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

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    size: json["size"],
    mimeType: json["mime_type"],
    baseName: json["base_name"],
    friendlySize: json["friendly_size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "size": size,
    "mime_type": mimeType,
    "base_name": baseName,
    "friendly_size": friendlySize,
  };
}
