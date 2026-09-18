import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
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