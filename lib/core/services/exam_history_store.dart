import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/exam_history_model.dart';
import 'token_service.dart';

/// Persists completed exam summaries for the Results tab.
///
/// `GET /questions/history` returns a single answer-attempt object (or null),
/// not exam-level summaries. Full Results cards are therefore stored locally
/// after a successful submit, scoped per user id.
class ExamHistoryStore {
  static const _keyPrefix = 'exam_history_';

  final SharedPreferences _prefs;
  final TokenService _tokenService;

  ExamHistoryStore({
    required SharedPreferences prefs,
    required TokenService tokenService,
  })  : _prefs = prefs,
        _tokenService = tokenService;

  Future<List<ExamHistoryModel>> getAll() async {
    final key = await _storageKey();
    if (key == null) return [];

    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return [];

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map>()
          .map((e) => ExamHistoryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(ExamHistoryModel entry) async {
    final key = await _storageKey();
    if (key == null) return;

    final existing = await getAll();
    final updated = [entry, ...existing.where((e) => e.id != entry.id)];
    await _prefs.setString(
      key,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearForCurrentUser() async {
    final key = await _storageKey();
    if (key == null) return;
    await _prefs.remove(key);
  }

  Future<String?> _storageKey() async {
    final userId = await _tokenService.getUserId();
    if (userId == null || userId.isEmpty) return null;
    return '$_keyPrefix$userId';
  }
}
