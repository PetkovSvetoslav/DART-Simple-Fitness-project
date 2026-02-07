class LockerService {
  final int lockerCount;
  final Map<int, int> lockerToPersonId = {}; // lockerNumber -> personId

  LockerService({required this.lockerCount}) {
    if (lockerCount <= 0) throw ArgumentError('lockerCount must be > 0');
  }

  bool isOccupied(int lockerNumber) => lockerToPersonId.containsKey(lockerNumber);

  int? occupiedBy(int lockerNumber) => lockerToPersonId[lockerNumber];

  void occupyLocker({required int lockerNumber, required int personId}) {
    _validateLockerNumber(lockerNumber);

    if (lockerToPersonId.containsKey(lockerNumber)) {
      final current = lockerToPersonId[lockerNumber];
      throw StateError('Locker $lockerNumber already occupied by personId=$current');
    }

    // Optional rule: one person can occupy only one locker
    if (lockerToPersonId.values.contains(personId)) {
      throw StateError('personId=$personId already occupies a locker');
    }

    lockerToPersonId[lockerNumber] = personId;
  }

  void releaseLocker({required int lockerNumber, required int personId}) {
    _validateLockerNumber(lockerNumber);

    final current = lockerToPersonId[lockerNumber];
    if (current == null) {
      throw StateError('Locker $lockerNumber is not occupied');
    }
    if (current != personId) {
      throw StateError('Locker $lockerNumber is occupied by personId=$current, not $personId');
    }

    lockerToPersonId.remove(lockerNumber);
  }

  String status() {
    final buffer = StringBuffer();
    for (int i = 1; i <= lockerCount; i++) {
      final occ = lockerToPersonId[i];
      buffer.writeln(occ == null ? 'Locker $i: FREE' : 'Locker $i: OCCUPIED by id=$occ');
    }
    return buffer.toString();
  }

  void _validateLockerNumber(int lockerNumber) {
    if (lockerNumber < 1 || lockerNumber > lockerCount) {
      throw RangeError('lockerNumber must be between 1 and $lockerCount');
    }
  }
}
