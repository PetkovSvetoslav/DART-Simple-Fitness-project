import 'dart:convert';
import 'dart:html';

import 'package:fitness/services.dart';

class StorageService {
  static const _key = 'fitness_gym_state_v1';

  void save(InMemoryDb db) {
    window.localStorage[_key] = jsonEncode(db.toJson());
  }

  InMemoryDb? load() {
    final raw = window.localStorage[_key];
    if (raw == null || raw.trim().isEmpty) return null;
    return InMemoryDb.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  void clear() {
    window.localStorage.remove(_key);
  }
}

