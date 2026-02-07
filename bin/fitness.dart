import 'package:fitness/models.dart';
import 'package:fitness/services.dart';

void main() {
  final db = InMemoryDb();
  final access = GymAccessService(db);
  final lockers = LockerService(lockerCount: 5);

  try {
    // 1) Register person + assign card
    final p1 = access.registerPerson(Person(
      id: 1,
      name: 'Ivan Petrov',
      role: Role.trainee,
      number: '0888123456',
      email: 'ivan@example.com',
    ));

    access.assignCard(
      Card(personId: 1, typeOfCard: TypeOfCard.monthly),
    );

    print('=== INITIAL PERSON ===');
    print(p1);
    print('');

    // 2) Login (scan card)
    access.loginWithCard(1);
    print('=== AFTER LOGIN ===');
    print(p1);
    print('');

    // 3) Occupy locker
    lockers.occupyLocker(lockerNumber: 2, personId: 1);
    print('=== LOCKERS AFTER OCCUPY ===');
    print(lockers.status());
    print('');

    // (Optional demo) Try to occupy same locker again -> should error
    // lockers.occupyLocker(lockerNumber: 2, personId: 1);

    // 4) Release locker + logout
    lockers.releaseLocker(lockerNumber: 2, personId: 1);
    access.logoutWithCard(1);

    print('=== AFTER LOGOUT ===');
    print(p1);
    print('');

    print('=== LOCKERS AFTER RELEASE ===');
    print(lockers.status());
    print('');
  } catch (e, st) {
    print('ERROR: $e');
    // For debugging during development:
    // print(st);
  }
}
