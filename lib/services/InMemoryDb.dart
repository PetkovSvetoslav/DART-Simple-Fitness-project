import 'package:fitness/models.dart';

class InMemoryDb {
  final Map<int, Person> persons = {};
  final Map<int, Card> cardsByPersonId = {};
}