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

  @override
  String toString() =>
      'Person(id=$id, name=$name, role=$role, number=$number, email=$email, '
          'isLoggedIn=$isLoggedIn, lastLoginAt=$lastLoginAt, lastLogoutAt=$lastLogoutAt)';
}
