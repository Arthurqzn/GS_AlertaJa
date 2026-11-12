import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/occurrence.dart';

class LocalStore {
  LocalStore(this.prefs);
  final SharedPreferences prefs;
  static const introKey = 'intro_seen';
  static const recordsKey = 'occurrences';
  bool get introSeen => prefs.getBool(introKey) ?? false;
  Future<void> setIntroSeen(bool value) => prefs.setBool(introKey, value);

  bool _readFailed = false;
  List<Occurrence> getOccurrences() {
    final raw = prefs.getString(recordsKey);
    if (raw == null) return [];
    _readFailed = false;
    try {
      final list = jsonDecode(raw) as List;
      final items = <Occurrence>[];
      for (final entry in list) {
        if (entry is! Map) continue;
        try {
          final record = Occurrence.fromJson(Map<String, dynamic>.from(entry));
          if (record.id.isNotEmpty) items.add(record);
        } catch (_) { /* Preserve other valid records. */ }
      }
      items.sort((a,b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (_) { _readFailed = true; return []; }
  }

  Future<void> saveOccurrences(List<Occurrence> items) async {
    if (_readFailed) throw StateError('Dados armazenados inválidos; backup necessário antes de salvar.');
    await prefs.setString(recordsKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }
}
