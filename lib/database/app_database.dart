import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// import 區加呢行（⚠️ DB 檔會依賴 Flutter，想避免嘅話可以改寫死 codePoint 數字）
import 'package:flutter/material.dart' show Icons, IconData;

part 'app_database.g.dart';

// ---------- Tables ----------
@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  IntColumn get iconCodePoint => integer()(); // 對應 Icons.xxx.codePoint
  BoolColumn get isExpense => boolean()();     // 呢個 category 用喺邊邊(expense/income)
  // 新增:刪除分類但仍有交易用緊時,唔真刪,淨係封存
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@DataClassName('TransactionEntry')
class TransactionEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  BoolColumn get isExpense => boolean()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get footnote => text().nullable()();
// 已 confirm:唔需要 createdAt / updatedAt
}

// ---------- Database ----------

@DriftDatabase(tables: [Categories, TransactionEntries])
class AppDatabase extends _$AppDatabase {

  Future<void> _seedDefaultCategories() async {
    final defaults = <(String, IconData, bool)>[
      ('Food', Icons.restaurant, true),
      ('Transportation', Icons.directions_transit_sharp, true),
      ('Snack', Icons.shopping_bag_outlined, true),
      ('other', Icons.grid_view_outlined, true),
      ('Salary', Icons.payments_outlined, false),
      ('other', Icons.grid_view_outlined, false),
    ];
    await batch((b) {
      b.insertAll(categories, [
        for (final d in defaults)
          CategoriesCompanion.insert(
            label: d.$1,
            iconCodePoint: d.$2.codePoint,
            isExpense: d.$3,
          ),
      ]);
    });
  }

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultCategories();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(categories, categories.isArchived);
      }
    },
  );
}

// ② _openConnection 加 setup,開返 foreign key 檢查
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bookkeeping.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  });
}

