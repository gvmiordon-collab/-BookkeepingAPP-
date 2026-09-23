// lib/providers/fixed_item_provider.dart
import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:bookkeeping/database/app_database.dart';
import 'package:bookkeeping/home_page/drawer_pages/fixed_item/fixed_item_logic.dart';

class FixedItemProvider extends ChangeNotifier {
  final AppDatabase _db;
  StreamSubscription<List<FixedItem>>? _sub;

  List<FixedItem> _items = [];
  List<FixedItem> get items => _items;

  bool _generating = false; // 防止 catch-up 執行緊嗰陣自己觸發嘅 DB 更新再叫多次自己

  FixedItemProvider(this._db) {
    _sub = _db.select(_db.fixedItems).watch().listen((rows) {
      _items = [...rows]..sort((a, b) => a.id.compareTo(b.id));
      notifyListeners();
      runDueGeneration(); // ⚠️ App 開嗰陣 / list 一有更新就順便 catch-up 一次,唔使開額外 background task
    });
  }

  Future<void> addFixedItem(FixedItemDraft draft) {
    final now = DateTime.now();
    return _db.into(_db.fixedItems).insert(
      FixedItemsCompanion.insert(
        label: draft.label,
        amount: draft.amount,
        isExpense: draft.isExpense,
        categoryId: draft.categoryId,
        assetId: Value(draft.assetId),
        frequencyType: draft.frequencyType,
        scheduleDays: FixedItemLogic.scheduleDaysToString(draft.scheduleDays),
        repeatedTimes: Value(draft.repeatedTimes),
        startDate: DateTime(now.year, now.month, now.day),
      ),
    );
  }

  // ← 加:編輯已存在嘅 fixed item。startDate/occurrenceCount/lastGeneratedDate 冇郁,
  // 保持原有嘅生成進度,唔會因為改咗個名/金額就成個重新計過
  Future<void> updateFixedItem(int id, FixedItemDraft draft) {
    return (_db.update(_db.fixedItems)..where((tbl) => tbl.id.equals(id))).write(
      FixedItemsCompanion(
        label: Value(draft.label),
        amount: Value(draft.amount),
        isExpense: Value(draft.isExpense),
        categoryId: Value(draft.categoryId),
        assetId: Value(draft.assetId),
        frequencyType: Value(draft.frequencyType),
        scheduleDays: Value(FixedItemLogic.scheduleDaysToString(draft.scheduleDays)),
        repeatedTimes: Value(draft.repeatedTimes),
      ),
    );
  }

  Future<void> deleteFixedItem(int id) {
    return (_db.delete(_db.fixedItems)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 撳個 Switch。⚠️ 由熄轉開嗰陣,將 lastGeneratedDate 校做「今日前一日」,
  /// 咁樣熄咗嗰段時間唔會一次過補晒啲舊 transaction 返嚟(避免嚇親人)。
  Future<void> setActive(int id, bool active) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return (_db.update(_db.fixedItems)..where((tbl) => tbl.id.equals(id))).write(
      FixedItemsCompanion(
        isActive: Value(active),
        lastGeneratedDate: active
            ? Value(today.subtract(const Duration(days: 1)))
            : const Value.absent(),
      ),
    );
  }

  /// 檢查晒所有啟用緊嘅 fixed item,將漏咗嘅日子補返做 transaction。
  Future<void> runDueGeneration() async {
    if (_generating) return;
    _generating = true;
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      for (final item in _items) {
        if (!item.isActive) continue;
        if (item.repeatedTimes != null && item.occurrenceCount >= item.repeatedTimes!) continue;

        final due = FixedItemLogic.dueDatesInRange(
          frequencyType: item.frequencyType,
          scheduleDays: FixedItemLogic.scheduleDaysFromString(item.scheduleDays),
          start: item.lastGeneratedDate ?? item.startDate.subtract(const Duration(days: 1)),
          end: today,
        );
        if (due.isEmpty) continue;

        final remaining = item.repeatedTimes == null
            ? due.length
            : (item.repeatedTimes! - item.occurrenceCount).clamp(0, due.length);
        final toGenerate = due.take(remaining).toList();
        if (toGenerate.isEmpty) continue;

        await _db.batch((b) {
          b.insertAll(_db.transactionEntries, [
            for (final d in toGenerate)
              TransactionEntriesCompanion.insert(
                date: d,
                amount: item.amount,
                isExpense: item.isExpense,
                categoryId: item.categoryId,
                assetId: Value(item.assetId),
                footnote: Value(item.label),
              ),
          ]);
        });

        await (_db.update(_db.fixedItems)..where((tbl) => tbl.id.equals(item.id))).write(
          FixedItemsCompanion(
            occurrenceCount: Value(item.occurrenceCount + toGenerate.length),
            lastGeneratedDate: Value(toGenerate.last),
          ),
        );
      }
    } finally {
      _generating = false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}