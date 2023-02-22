class PurpleFile {
  PurpleFile({
    this.status,
    this.file,
  });

  String status;
  FileClass file;

  factory PurpleFile.fromJson(Map<String, dynamic> json) => PurpleFile(
    status: json["status"],
    file: FileClass.fromJson(json["file"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "file": file.toJson(),
  };
}

class FileClass {
  FileClass({
    this.id,
    this.userId,
    this.name,
    this.link,
    this.thumbnailLink,
    this.size,
    this.mimeType,
    this.baseName,
    this.friendlySize,
  });

  int id;
  int userId;
  String name;
  String link;
  String thumbnailLink;
  int size;
  String mimeType;
  String baseName;
  String friendlySize;

  factory FileClass.fromJson(Map<String, dynamic> json) => FileClass(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    link: json["link"],
    thumbnailLink: json["thumbnail_link"],
    size: json["size"],
    mimeType: json["mime_type"],
    baseName: json["base_name"],
    friendlySize: json["friendly_size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "link": link,
    "thumbnail_link": thumbnailLink,
    "size": size,
    "mime_type": mimeType,
    "base_name": baseName,
    "friendly_size": friendlySize,
  };
}
