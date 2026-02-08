import 'package:fitness/models.dart';
import 'package:fitness/services.dart';

void main() {
  final db = InMemoryDb();
  final lockers = LockerService(db, lockerCount: 5);
  final access = GymAccessService(db, lockers);

  final p1 = access.registerPerson(Person(
    id: 1,
    name: 'Ivan Petrov',
    role: Role.trainee,
    number: '0888123456',
    email: 'ivan@example.com',
  ));

  access.assignCard(Card(personId: 1, cardCode: 'C-1001', typeOfCard: TypeOfCard.monthly));

  access.loginWithCardCode('C-1001');
  lockers.occupyLocker(lockerNumber: 2, personId: 1);

  lockers.releaseLocker(lockerNumber: 2, personId: 1);
  access.logout(1);

  print(p1);
}
