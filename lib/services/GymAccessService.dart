import '../models/Person.dart';
import '../models/Card.dart';
import 'InMemoryDb.dart';


class GymAccessService {
  final InMemoryDb db;

  GymAccessService(this.db);

  Person registerPerson(Person person) {
    if (db.persons.containsKey(person.id)) {
      throw StateError('Person with id=${person.id} already exists');
    }
    db.persons[person.id] = person;
    return person;
  }

  Card assignCard(Card card) {
    if (!db.persons.containsKey(card.personId)) {
      throw StateError('Cannot assign card: personId=${card.personId} not found');
    }
    db.cardsByPersonId[card.personId] = card;
    return card;
  }

  /// Login by personId (representing scanning card).
  Person loginWithCard(int personId) {
    final person = db.persons[personId];
    if (person == null) {
      throw StateError('Login failed: personId=$personId not found');
    }
    if (!db.cardsByPersonId.containsKey(personId)) {
      throw StateError('Login failed: personId=$personId has no card assigned');
    }
    if (person.isLoggedIn) {
      throw StateError('Login failed: personId=$personId already logged in');
    }

    person.isLoggedIn = true;
    person.lastLoginAt = DateTime.now();
    return person;
  }

  Person logoutWithCard(int personId) {
    final person = db.persons[personId];
    if (person == null) {
      throw StateError('Logout failed: personId=$personId not found');
    }
    if (!db.cardsByPersonId.containsKey(personId)) {
      throw StateError('Logout failed: personId=$personId has no card assigned');
    }
    if (!person.isLoggedIn) {
      throw StateError('Logout failed: personId=$personId is not logged in');
    }

    person.isLoggedIn = false;
    person.lastLogoutAt = DateTime.now();
    return person;
  }
}