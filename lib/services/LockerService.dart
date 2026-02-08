import 'InMemoryDb.dart';
import '../models/GymEvent.dart';

class LockerService {
  final InMemoryDb db;
  final int lockerCount;

  LockerService(this.db, {required this.lockerCount});

  bool personHasLocker(int personId) => db.lockerToPersonId.values.contains(personId);

  int? lockerOfPerson(int personId) {
    for (final e in db.lockerToPersonId.entries) {
      if (e.value == personId) return e.key;
    }
    return null;
  }

  void occupyLocker({required int lockerNumber, required int personId}) {
    _validateLockerNumber(lockerNumber);

    final person = db.persons[personId];
    if (person == null) throw StateError('Person not found: id=$personId');
    if (!person.isLoggedIn) throw StateError('Cannot occupy locker: personId=$personId is not logged in');

    if (db.lockerToPersonId.containsKey(lockerNumber)) {
      throw StateError('Locker $lockerNumber already occupied by id=${db.lockerToPersonId[lockerNumber]}');
    }

    final existingLocker = lockerOfPerson(personId);
    if (existingLocker != null) {
      throw StateError('Person id=$personId already occupies locker $existingLocker');
    }

    db.lockerToPersonId[lockerNumber] = personId;

    db.events.add(GymEvent(
      time: DateTime.now(),
      type: GymEventType.occupyLocker,
      personId: personId,
      lockerNumber: lockerNumber,
      message: 'Occupied locker $lockerNumber',
    ));
  }

  void releaseLocker({required int lockerNumber, required int personId}) {
    _validateLockerNumber(lockerNumber);

    final current = db.lockerToPersonId[lockerNumber];
    if (current == null) throw StateError('Locker $lockerNumber is already free');
    if (current != personId) throw StateError('Locker $lockerNumber is occupied by id=$current (not id=$personId)');

    db.lockerToPersonId.remove(lockerNumber);

    db.events.add(GymEvent(
      time: DateTime.now(),
      type: GymEventType.releaseLocker,
      personId: personId,
      lockerNumber: lockerNumber,
      message: 'Released locker $lockerNumber',
    ));
  }

  String status() {
    final b = StringBuffer();
    for (int i = 1; i <= lockerCount; i++) {
      final occupant = db.lockerToPersonId[i];
      b.writeln(occupant == null ? 'Locker $i: FREE' : 'Locker $i: OCCUPIED by id=$occupant');
    }
    return b.toString();
  }

  void _validateLockerNumber(int lockerNumber) {
    if (lockerNumber < 1 || lockerNumber > lockerCount) {
      throw StateError('Invalid lockerNumber=$lockerNumber (1..$lockerCount)');
    }
  }
}
