import 'dart:html';

import 'package:fitness/models.dart';
import 'package:fitness/services.dart';

import 'render.dart';
import 'storage.dart';

class Handlers {
  InMemoryDb db;
  final int lockerCount;

  late LockerService lockers;
  late GymAccessService access;

  final Renderer renderer;
  final StorageService storage = StorageService();

  Handlers(this.db, {required this.lockerCount})
      : renderer = Renderer(db, lockerCount: lockerCount) {
    _rebuildServices();
  }

  void bind() {
    (querySelector('#btnRegister') as ButtonElement).onClick.listen((_) => _safe(_register));
    (querySelector('#btnAssignCard') as ButtonElement).onClick.listen((_) => _safe(_assignCard));
    (querySelector('#btnScanLogin') as ButtonElement).onClick.listen((_) => _safe(_scanLogin));
    (querySelector('#btnLogout') as ButtonElement).onClick.listen((_) => _safe(_logout));
    (querySelector('#btnOccupy') as ButtonElement).onClick.listen((_) => _safe(_occupy));
    (querySelector('#btnRelease') as ButtonElement).onClick.listen((_) => _safe(_release));

    (querySelector('#btnSave') as ButtonElement).onClick.listen((_) => _safe(_save));
    (querySelector('#btnLoad') as ButtonElement).onClick.listen((_) => _safe(_load));
    (querySelector('#btnReset') as ButtonElement).onClick.listen((_) => _safe(_reset));

    renderer.renderAll();
  }

  void _rebuildServices() {
    lockers = LockerService(db, lockerCount: lockerCount);
    access = GymAccessService(db, lockers);
  }

  void _safe(void Function() action) {
    renderer.clearError();
    try {
      action();
      renderer.renderAll();
    } catch (e) {
      renderer.showError(e.toString());
      renderer.renderAll();
    }
  }

  void _register() {
    final id = _int('#personId');
    final name = _str('#name');
    final role = _roleFromUi(_str('#role'));
    final number = _str('#number');
    final email = _str('#email');

    access.registerPerson(Person(
      id: id,
      name: name,
      role: role,
      number: number,
      email: email,
    ));
  }

  void _assignCard() {
    final personId = _int('#cardPersonId');
    final cardCode = _str('#cardCode');
    final type = _cardTypeFromUi(_str('#cardType'));

    access.assignCard(Card(personId: personId, cardCode: cardCode, typeOfCard: type));
  }

  void _scanLogin() {
    final code = _str('#scanCode');
    access.loginWithCardCode(code);
  }

  void _logout() {
    final current = db.currentSessionPersonId;
    if (current == null) throw StateError('No active session to logout');
    access.logout(current);
  }

  void _occupy() {
    final lockerNumber = _int('#lockerNumber');
    final personId = _int('#lockerPersonId');
    lockers.occupyLocker(lockerNumber: lockerNumber, personId: personId);
  }

  void _release() {
    final lockerNumber = _int('#lockerNumber');
    final personId = _int('#lockerPersonId');
    lockers.releaseLocker(lockerNumber: lockerNumber, personId: personId);
  }

  void _save() => storage.save(db);

  void _load() {
    final loaded = storage.load();
    if (loaded == null) throw StateError('No saved state found');
    db = loaded;
    _rebuildServices();
    // rebuild renderer’s db reference
    renderer.db.persons
      ..clear()
      ..addAll(db.persons);
  }

  void _reset() {
    storage.clear();
    db = InMemoryDb();
    _rebuildServices();
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
}

