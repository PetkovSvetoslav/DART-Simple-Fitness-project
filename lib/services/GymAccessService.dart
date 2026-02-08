import '../models/Person.dart';
import '../models/Card.dart';
import '../models/GymEvent.dart';
import 'InMemoryDb.dart';
import 'LockerService.dart';

class GymAccessService {
  final InMemoryDb db;
  final LockerService lockers;

  GymAccessService(this.db, this.lockers);

  Person registerPerson(Person person) {
    _validatePerson(person);

    if (db.persons.containsKey(person.id)) {
      throw StateError('Person with id=${person.id} already exists');
    }

    // unique email/number
    final emailLower = person.email.trim().toLowerCase();
    for (final p in db.persons.values) {
      if (p.email.trim().toLowerCase() == emailLower) {
        throw StateError('Email already used: ${person.email}');
      }
      if (p.number.trim() == person.number.trim()) {
        throw StateError('Number already used: ${person.number}');
      }
    }

    db.persons[person.id] = person;

    db.events.add(GymEvent(
      time: DateTime.now(),
      type: GymEventType.register,
      personId: person.id,
      message: 'Registered ${person.name}',
    ));

    return person;
  }

  Card assignCard(Card card) {
    if (!db.persons.containsKey(card.personId)) {
      throw StateError('Cannot assign card: personId=${card.personId} not found');
    }
    if (db.cardsByPersonId.containsKey(card.personId)) {
      throw StateError('Person id=${card.personId} already has a card');
    }
    if (db.personIdByCardCode.containsKey(card.cardCode)) {
      throw StateError('Card code already assigned: ${card.cardCode}');
    }

    db.cardsByPersonId[card.personId] = card;
    db.personIdByCardCode[card.cardCode] = card.personId;

    db.events.add(GymEvent(
      time: DateTime.now(),
      type: GymEventType.assignCard,
      personId: card.personId,
      message: 'Assigned card ${card.cardCode} (${card.typeOfCard.name})',
    ));

    return card;
  }

  /// Auth simulation: scan cardCode
  Person loginWithCardCode(String cardCode) {
    final personId = db.personIdByCardCode[cardCode.trim()];
    if (personId == null) throw StateError('Login failed: card not found');

    final person = db.persons[personId]!;
    if (person.isLoggedIn) throw StateError('Login failed: already logged in');

    person.isLoggedIn = true;
    person.lastLoginAt = DateTime.now();
    db.currentSessionPersonId = personId;

    db.events.add(GymEvent(
      time: DateTime.now(),
      type: GymEventType.login,
      personId: personId,
      message: 'Logged in by card scan',
    ));

    return person;
  }

  Person logout(int personId) {
    final person = db.persons[personId];
    if (person == null) throw StateError('Logout failed: personId=$personId not found');
    if (!db.cardsByPersonId.containsKey(personId)) {
      throw StateError('Logout failed: personId=$personId has no card assigned');
    }
    if (!person.isLoggedIn) throw StateError('Logout failed: personId=$personId is not logged in');

    // rule: cannot logout if locker occupied
    final existingLocker = lockers.lockerOfPerson(personId);
    if (existingLocker != null) {
      throw StateError('Logout blocked: release locker $existingLocker first');
    }

    person.isLoggedIn = false;
    person.lastLogoutAt = DateTime.now();

    if (db.currentSessionPersonId == personId) db.currentSessionPersonId = null;

    db.events.add(GymEvent(
      time: DateTime.now(),
      type: GymEventType.logout,
      personId: personId,
      message: 'Logged out',
    ));

    return person;
  }

  void _validatePerson(Person p) {
    if (p.name.trim().isEmpty) throw StateError('Name is required');
    if (p.number.trim().isEmpty) throw StateError('Number is required');
    if (p.email.trim().isEmpty) throw StateError('Email is required');

    final email = p.email.trim();
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!emailOk) throw StateError('Invalid email: $email');
  }
}
