
class User {
  final int id;
  final String name;
  String? surname;
  final String fullName;
  final String shortName;
  final String email;
  final String roleName;
  String? avatar;
  final String? phoneCode;
  final String? phone;
  final String? gender;
  final String? bdate;

  User ({
    required this.id,
    required this.name,
    this.surname,
    required this.fullName,
    required this.shortName,
    required this.email,
    required this.roleName,
    this.avatar,
    this.phoneCode,
    this.phone,
    this.gender,
    this.bdate,
  });
  static User fromJson(json) => User(
    id: json['id'],
    name: json['name'],
    surname: json['surname'],
    fullName: json['full_name'],
    shortName: json['short_name'],
    email: json['email'],
    roleName: json['role_name'],
    avatar: json['avatar_url'],
    phoneCode: json['phone_code'],
    phone: json['phone'],
    gender: json['gender'],
    bdate: json['bdate']
  );
}