import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:bookkeeping/database/app_database.dart';

class TransactionProvider extends ChangeNotifier {
  final AppDatabase _db;
  StreamSubscription<List<TransactionEntry>>? _sub;

  List<TransactionEntry> _transactions = [];
  List<TransactionEntry> get transactions => _transactions;

  TransactionProvider(this._db) {
    _sub = _db.select(_db.transactionEntries).watch().listen((rows) {
      _transactions = rows;
      notifyListeners();
    });
  }

  // ---------- 查詢 / 統計(俾 Home page 嗰啲 summary widget 用) ----------

  List<TransactionEntry> transactionsForMonth(DateTime month) {
    return _transactions
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .toList()
      ..sort((a, b) {
        final c = b.date.compareTo(a.date);
        return c != 0 ? c : b.id.compareTo(a.id); // 同日 → 新入嗰筆(id 大)排前
      });
  }

  /// 俾 TransactionsTable 逐日 render 用
  Map<DateTime, List<TransactionEntry>> transactionsGroupedByDate(DateTime month) {
    final result = <DateTime, List<TransactionEntry>>{};
    for (final t in transactionsForMonth(month)) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      result.putIfAbsent(day, () => []).add(t);
    }
    return result;
  }

  double totalExpenseForMonth(DateTime month) => transactionsForMonth(month)
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double totalIncomeForMonth(DateTime month) => transactionsForMonth(month)
      .where((t) => !t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double balanceForMonth(DateTime month) =>
      totalIncomeForMonth(month) - totalExpenseForMonth(month);

  // ---------- CRUD ----------

  Future<void> addTransaction({
    required DateTime date,
    required double amount,
    required bool isExpense,
    required int categoryId,
    String? footnote,
  }) {
    return _db.into(_db.transactionEntries).insert(
      TransactionEntriesCompanion.insert(
        date: date,
        amount: amount,
        isExpense: isExpense,
        categoryId: categoryId,
        footnote: Value(footnote),
      ),
    );
  }

  Future<void> updateTransaction(TransactionEntry entry) {
    return _db.update(_db.transactionEntries).replace(entry);
  }

  /// 編輯一筆交易(Calculator page 編輯模式儲存時用)
  Future<void> editTransaction({
    required int id,
    required DateTime date,
    required double amount,
    required bool isExpense,
    required int categoryId,
    String? footnote,
  }) {
    return _db.update(_db.transactionEntries).replace(
      TransactionEntry(
        id: id,
        date: date,
        amount: amount,
        isExpense: isExpense,
        categoryId: categoryId,
        footnote: footnote,
      ),
    );
  }

  Future<void> deleteTransaction(int id) {
    return (_db.delete(_db.transactionEntries)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}