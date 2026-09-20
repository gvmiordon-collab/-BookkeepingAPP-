import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:bookkeeping/database/app_database.dart';

class CategoryProvider extends ChangeNotifier {
  final AppDatabase _db;
  StreamSubscription<List<Category>>? _sub;

  List<Category> _categories = [];

  /// 全部 category,包括封存咗嗰啲 —— 顯示舊交易嘅分類名嗰陣要用呢個(唔可以漏)
  List<Category> get categories => _categories;

  /// 冇封存嘅 category —— 俾 calculator page 揀分類個 list 用
  List<Category> get activeCategories =>
      _categories.where((c) => !c.isArchived).toList();

  List<Category> get activeExpenseCategories =>
      activeCategories.where((c) => c.isExpense).toList();

  List<Category> get activeIncomeCategories =>
      activeCategories.where((c) => !c.isExpense).toList();

  List<Category> get archivedCategories =>
      _categories.where((c) => c.isArchived).toList();

  CategoryProvider(this._db) {
    _sub = _db.select(_db.categories).watch().listen((rows) {
      _categories = rows;
      notifyListeners();
    });
  }

  /// 用 id 揾返個 category(封存咗都揾到)—— 顯示舊 transaction 個分類名/icon 嗰陣用
  Category? categoryById(int id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> addCategory({
    required String label,
    required int iconCodePoint,
    required bool isExpense,
  }) {
    return _db.into(_db.categories).insert(
      CategoriesCompanion.insert(
        label: label,
        iconCodePoint: iconCodePoint,
        isExpense: isExpense,
      ),
    );
  }

  Future<void> updateCategory(Category category) {
    return _db.update(_db.categories).replace(category);
  }

  /// 由頭到尾都未用過(0 筆交易)→ 真係刪走
  /// 已經有交易用緊 → 唔會真刪,淨係封存(isArchived = true):
  ///   之後揀分類個 list 唔會再見到佢,但舊交易嘅分類名/記錄原封不動
  Future<void> deleteCategory(int id) async {
    final inUse = await (_db.select(_db.transactionEntries)
      ..where((t) => t.categoryId.equals(id)))
        .get();

    if (inUse.isEmpty) {
      await (_db.delete(_db.categories)..where((tbl) => tbl.id.equals(id))).go();
    } else {
      await (_db.update(_db.categories)..where((tbl) => tbl.id.equals(id)))
          .write(const CategoriesCompanion(isArchived: Value(true)));
    }
  }

  /// 想將封存咗嘅 category 攞返出嚟用(undo)
  Future<void> restoreCategory(int id) {
    return (_db.update(_db.categories)..where((tbl) => tbl.id.equals(id)))
        .write(const CategoriesCompanion(isArchived: Value(false)));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}