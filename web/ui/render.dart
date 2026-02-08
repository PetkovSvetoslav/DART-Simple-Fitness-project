import 'dart:html';

import 'package:fitness/services.dart';

class Renderer {
  final InMemoryDb db;
  final int lockerCount;

  final TableSectionElement peopleBody = querySelector('#peopleBody') as TableSectionElement;
  final DivElement lockersGrid = querySelector('#lockersGrid') as DivElement;
  final UListElement eventsList = querySelector('#eventsList') as UListElement;
  final SpanElement sessionBadge = querySelector('#sessionBadge') as SpanElement;
  final DivElement msg = querySelector('#msg') as DivElement;

  Renderer(this.db, {required this.lockerCount});

  void showError(String text) => msg.text = text;
  void clearError() => msg.text = '';

  void renderAll() {
    _renderSession();
    _renderPeople();
    _renderLockers();
    _renderEvents();
  }

  void _renderSession() {
    final id = db.currentSessionPersonId;
    if (id == null) {
      sessionBadge.text = 'none';
      return;
    }
    final p = db.persons[id];
    sessionBadge.text = p == null ? 'id=$id' : '${p.name} (id=$id)';
  }

  void _renderPeople() {
    peopleBody.children.clear();

    final ids = db.persons.keys.toList()..sort();
    for (final id in ids) {
      final p = db.persons[id]!;
      final tr = TableRowElement();
      tr.children.addAll([
        TableCellElement()..text = p.id.toString(),
        TableCellElement()..text = p.name,
        TableCellElement()..text = p.role.name,
        TableCellElement()..text = p.isLoggedIn ? 'YES' : 'NO',
        TableCellElement()..text = p.lastLoginAt?.toString() ?? '-',
        TableCellElement()..text = p.lastLogoutAt?.toString() ?? '-',
      ]);
      peopleBody.children.add(tr);
    }
  }

  void _renderLockers() {
    lockersGrid.children.clear();

    for (int i = 1; i <= lockerCount; i++) {
      final occupant = db.lockerToPersonId[i];
      final box = DivElement()
        ..className = 'locker ' + (occupant == null ? 'free' : 'busy');

      box.children.add(HeadingElement.h4()..text = 'Locker $i');
      box.children.add(ParagraphElement()
        ..text = occupant == null ? 'FREE' : 'OCCUPIED by id=$occupant');

      lockersGrid.children.add(box);
    }
  }

  void _renderEvents() {
    eventsList.children.clear();

    final last = db.events.reversed.take(25).toList();
    for (final e in last) {
      final li = LIElement()
        ..text = '${e.time.toLocal()} | ${e.type.name} | personId=${e.personId}'
            '${e.lockerNumber == null ? '' : ' | locker=${e.lockerNumber}'}'
            ' | ${e.message}';
      eventsList.children.add(li);
    }
  }
}

