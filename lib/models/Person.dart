import 'Role.dart';

class Person {
  final int id;
  String name;
  Role role;
  String number;
  String email;

  bool isLoggedIn;
  DateTime? lastLoginAt;
  DateTime? lastLogoutAt;

  Person({
    required this.id,
    required this.name,
    required this.role,
    required this.number,
    required this.email,
    this.isLoggedIn = false,
    this.lastLoginAt,
    this.lastLogoutAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role.name,
    'number': number,
    'email': email,
    'isLoggedIn': isLoggedIn,
    'lastLoginAt': lastLoginAt?.toIso8601String(),
    'lastLogoutAt': lastLogoutAt?.toIso8601String(),
  };

  static Person fromJson(Map<String, dynamic> json) => Person(
    id: json['id'] as int,
    name: json['name'] as String,
    role: Role.values.byName(json['role'] as String),
    number: json['number'] as String,
    email: json['email'] as String,
    isLoggedIn: (json['isLoggedIn'] as bool?) ?? false,
    lastLoginAt: (json['lastLoginAt'] as String?) == null
        ? null
        : DateTime.parse(json['lastLoginAt'] as String),
    lastLogoutAt: (json['lastLogoutAt'] as String?) == null
        ? null
        : DateTime.parse(json['lastLogoutAt'] as String),
  );

  @override
  String toString() =>
      'Person(id=$id, name=$name, role=$role, number=$number, email=$email, '
          'isLoggedIn=$isLoggedIn, lastLoginAt=$lastLoginAt, lastLogoutAt=$lastLogoutAt)';
}

