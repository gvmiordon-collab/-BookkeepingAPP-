// lib/providers/footnote_provider.dart
import 'dart:async';
import 'package:drift/drift.dart' show Value, OrderingTerm;
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:bookkeeping/database/app_database.dart';

class FootnoteProvider extends ChangeNotifier {
  final AppDatabase _db;
  StreamSubscription<List<FootnoteTag>>? _sub;

  List<FootnoteTag> _footnotes = [];

  FootnoteProvider(this._db) {
    final query = _db.select(_db.footnotes)
      ..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)]);
    _sub = query.watch().listen((rows) {
      _footnotes = rows;
      notifyListeners();
    });
  }

  /// 全部,已經按最近使用排先 —— More bottom sheet 用
  List<FootnoteTag> get all => _footnotes;

  /// 最近用開 5 個 —— horizontal list 用
  List<FootnoteTag> get recent => _footnotes.take(5).toList();

  /// 撳 OK 儲存交易嗰陣、footnote 有嘢就 call:
  /// 同名已經存在 → 淨係更新 lastUsedAt(跳返上最近使用);未存在 → 新增
  Future<void> recordUsage(String label) async {
    final trimmed = label.trim();
    if (trimmed.isEmpty) return;
    final now = DateTime.now();
    final existing = await (_db.select(_db.footnotes)
      ..where((t) => t.label.equals(trimmed)))
        .getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.footnotes)..where((t) => t.id.equals(existing.id)))
          .write(FootnotesCompanion(lastUsedAt: Value(now)));
    } else {
      await _db.into(_db.footnotes).insert(
        FootnotesCompanion.insert(label: trimmed, lastUsedAt: now),
      );
    }
  }

  /// 刪走一個建議 footnote —— 淨係影響 list,唔會改到已經儲低嘅舊交易(交易個 footnote 係自由文字,冇連 foreign key)
  Future<void> deleteFootnote(int id) {
    return (_db.delete(_db.footnotes)..where((t) => t.id.equals(id))).go();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}