import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ---------- Tables ----------

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  IntColumn get iconCodePoint => integer()(); // 對應 Icons.xxx.codePoint
  BoolColumn get isExpense => boolean()();     // 呢個 category 用喺邊邊(expense/income)
}

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
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bookkeeping.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}