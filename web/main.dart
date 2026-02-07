import 'dart:html';

import 'package:fitness/models.dart';
import 'package:fitness/services.dart';

final output = querySelector('#output') as PreElement;

final db = InMemoryDb();
final access = GymAccessService(db);
final lockers = LockerService(lockerCount: 5);

void main() {
  _bind();
  _render('Ready.');
}

void _bind() {
  (querySelector('#btnRegister') as ButtonElement).onClick.listen((_) => _safe(_register));
  (querySelector('#btnAssignCard') as ButtonElement).onClick.listen((_) => _safe(_assignCard));
  (querySelector('#btnLogin') as ButtonElement).onClick.listen((_) => _safe(_login));
  (querySelector('#btnLogout') as ButtonElement).onClick.listen((_) => _safe(_logout));
  (querySelector('#btnOccupy') as ButtonElement).onClick.listen((_) => _safe(_occupy));
  (querySelector('#btnRelease') as ButtonElement).onClick.listen((_) => _safe(_release));
}

void _safe(void Function() action) {
  try {
    action();
  } catch (e) {
    _render('ERROR: $e');
  }
}

void _register() {
  final id = _int('#personId');
  final name = _str('#name');
  final role = _roleFromUi(_str('#role'));
  final number = _str('#number');
  final email = _str('#email');

  final p = Person(id: id, name: name, role: role, number: number, email: email);
  access.registerPerson(p);

  _render('Registered:\n$p');
}

void _assignCard() {
  final personId = _int('#cardPersonId');
  final type = _cardTypeFromUi(_str('#cardType'));

  access.assignCard(Card(personId: personId, typeOfCard: type));
  _render('Card assigned to personId=$personId with type=$type\n\n${_status()}');
}

void _login() {
  final personId = _int('#cardPersonId');
  final p = access.loginWithCard(personId);
  _render('Logged in:\n$p\n\n${_status()}');
}

void _logout() {
  final personId = _int('#cardPersonId');
  final p = access.logoutWithCard(personId);
  _render('Logged out:\n$p\n\n${_status()}');
}

void _occupy() {
  final lockerNumber = _int('#lockerNumber');
  final personId = _int('#lockerPersonId');

  lockers.occupyLocker(lockerNumber: lockerNumber, personId: personId);
  _render('Locker occupied.\n\n${_status()}');
}

void _release() {
  final lockerNumber = _int('#lockerNumber');
  final personId = _int('#lockerPersonId');

  lockers.releaseLocker(lockerNumber: lockerNumber, personId: personId);
  _render('Locker released.\n\n${_status()}');
}

String _status() {
  final people = db.persons.values.map((p) => p.toString()).join('\n');
  return '=== PEOPLE ===\n${people.isEmpty ? "(none)" : people}\n\n=== LOCKERS ===\n${lockers.status()}';
}

int _int(String selector) => int.parse((querySelector(selector) as InputElement).value!.trim());
String _str(String selector) => (querySelector(selector) as dynamic).value.toString().trim();

Role _roleFromUi(String value) => value == 'worker' ? Role.worker : Role.trainee;

TypeOfCard _cardTypeFromUi(String v) {
  switch (v) {
    case 'monthly':
      return TypeOfCard.monthly;
    case 'quarterly':
      return TypeOfCard.quarterly;
    case 'sixMonthly':
      return TypeOfCard.sixMonthly;
    case 'yearly':
      return TypeOfCard.yearly;
    default:
      return TypeOfCard.monthly;
  }
}

void _render(String text) {
  output.text = text;
}
