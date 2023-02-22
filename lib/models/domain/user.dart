class User {

  String name;
  String position;
  String avatarUrl;
  User();

  Map<String, dynamic> toJson() => {
        'name': name,
        'position': position,
        'avatarUrl': avatarUrl,
      };

   User.fromJson(Map<String, dynamic> map):
         name= map['name'],
         position = map['position'],
         avatarUrl = map['avatarUrl'];
}
