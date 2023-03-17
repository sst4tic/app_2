
class User {
  final int id;
  final String name;
  String? surname;
  final String fullName;
  final String shortName;
  final String roleName;
  String? avatar;

   User ({
    required this.id,
    required this.name,
    this.surname,
    required this.fullName,
    required this.shortName,
    required this.roleName,
    this.avatar,

  });
  static User fromJson(json) => User(
    id: json['id'],
    name: json['name'],
    surname: json['surname'],
    fullName: json['full_name'],
    shortName: json['short_name'],
    roleName: json['role_name'],
    avatar: json['avatar_url'],
  );
}