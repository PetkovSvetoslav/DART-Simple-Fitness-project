import '../models/Person.dart';
import '../models/Card.dart';
import '../models/GymEvent.dart';

class InMemoryDb {
  final Map<int, Person> persons = {}; // key: personId
  final Map<int, Card> cardsByPersonId = {}; // one card per person
  final Map<String, int> personIdByCardCode = {}; // scan -> personId

  final Map<int, int> lockerToPersonId = {}; // lockerNumber -> personId
  final List<GymEvent> events = [];

  int? currentSessionPersonId; // UI convenience (active session)

  Map<String, dynamic> toJson() => {
    'persons': persons.values.map((p) => p.toJson()).toList(),
    'cards': cardsByPersonId.values.map((c) => c.toJson()).toList(),
    'lockerToPersonId': lockerToPersonId.map((k, v) => MapEntry(k.toString(), v)),
    'events': events.map((e) => e.toJson()).toList(),
    'currentSessionPersonId': currentSessionPersonId,
  };

  static InMemoryDb fromJson(Map<String, dynamic> json) {
    final db = InMemoryDb();

    final personsList = (json['persons'] as List<dynamic>? ?? []);
    for (final p in personsList) {
      final person = Person.fromJson((p as Map).cast<String, dynamic>());
      db.persons[person.id] = person;
    }

    final cardsList = (json['cards'] as List<dynamic>? ?? []);
    for (final c in cardsList) {
      final card = Card.fromJson((c as Map).cast<String, dynamic>());
      db.cardsByPersonId[card.personId] = card;
      db.personIdByCardCode[card.cardCode] = card.personId;
    }

    final lockerMap = (json['lockerToPersonId'] as Map<dynamic, dynamic>? ?? {});
    lockerMap.forEach((k, v) {
      db.lockerToPersonId[int.parse(k.toString())] = v as int;
    });

    final eventsList = (json['events'] as List<dynamic>? ?? []);
    for (final e in eventsList) {
      db.events.add(GymEvent.fromJson((e as Map).cast<String, dynamic>()));
    }

    db.currentSessionPersonId = json['currentSessionPersonId'] as int?;
    return db;
  }
}
