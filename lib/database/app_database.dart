import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
// ⚠️ 淨係 migration 4 用嚟將舊 codePoint 轉成 key(所以 DB 檔仲係依賴 Flutter)
import 'package:bookkeeping/utils/category_icon.dart';

part 'app_database.g.dart';

// ---------- Tables ----------
@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  // 對應 kCategoryIcons 嘅 key(例如 'restaurant')。
  // 有 default 係因為 migration 用 ADD COLUMN 加 NOT NULL 欄一定要有 default;
  // 同時 key 對唔到 map 嗰陣都會 fallback 去呢個。
  TextColumn get iconKey =>
      text().withDefault(const Constant(kDefaultCategoryIconKey))();
  BoolColumn get isExpense => boolean()();     // 呢個 category 用喺邊邊(expense/income)
  // 刪除分類但仍有交易用緊時,唔真刪,淨係封存
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@DataClassName('AssetAccount')
class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

@DataClassName('TransactionEntry')
class TransactionEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get amount => real()();
  BoolColumn get isExpense => boolean()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  // ⚠️ 一定要 nullable:SQLite ADD COLUMN 帶 REFERENCES 而 foreign_keys 開咗嘅話,default 必須係 NULL
  IntColumn get assetId => integer().nullable().references(Assets, #id)();
  TextColumn get footnote => text().nullable()();
// 已 confirm:唔需要 createdAt / updatedAt
}

@DataClassName('FixedItem')
class FixedItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  RealColumn get amount => real()();
  BoolColumn get isExpense => boolean()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get assetId => integer().nullable().references(Assets, #id)();
  // 0 = weekly, 1 = monthly(Annually 喺畫面度仲鎖緊,呢度未做呢個 case)
  IntColumn get frequencyType => integer()();
  // weekly: 1~7(Mon~Sun)逗號分隔;monthly: 1~31 逗號分隔
  TextColumn get scheduleDays => text()();
  // null = Unlimited,有數就係生成上限次數
  IntColumn get repeatedTimes => integer().nullable()();
  IntColumn get occurrenceCount => integer().withDefault(const Constant(0))();
  // 由邊一日開始計(冇畫面揀,default = 新增嗰刻)
  DateTimeColumn get startDate => dateTime()();
  // 自動生成計到邊一日(null = 未生成過)
  DateTimeColumn get lastGeneratedDate => dateTime().nullable()();
  // 即係畫面嗰個 Switch
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('FootnoteTag')                       // ← 加成個 class,擺喺 FixedItems table 後面
class Footnotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  DateTimeColumn get lastUsedAt => dateTime()();
}

// ---------- Database ----------

@DriftDatabase(tables: [Categories, TransactionEntries, Assets, FixedItems, Footnotes])
class AppDatabase extends _$AppDatabase {

  Future<void> _seedDefaultCategories() async {
    // (label, iconKey, isExpense)
    final defaults = <(String, String, bool)>[
      ('Food', 'restaurant', true),
      ('Transportation', 'transit', true),
      ('Snack', 'shopping_bag', true),
      ('other', 'grid_view', true),
      ('Salary', 'payments', false),
      ('other', 'grid_view', false),
    ];
    await batch((b) {
      b.insertAll(categories, [
        for (final d in defaults)
          CategoriesCompanion.insert(
            label: d.$1,
            iconKey: Value(d.$2),
            isExpense: d.$3,
          ),
      ]);
    });
  }

  /// 返回 Cash 嘅 id(migration 要用嚟歸戶舊交易)
  Future<int> _seedDefaultAssets() async {
    final cashId = await into(assets).insert(AssetsCompanion.insert(name: 'Cash'));
    await into(assets).insert(AssetsCompanion.insert(name: 'Bank'));
    return cashId;
  }

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultCategories();
      await _seedDefaultAssets();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(categories, categories.isArchived);
      }
      if (from < 3) {
        await m.createTable(assets);
        await m.addColumn(transactionEntries, transactionEntries.assetId);
        final cashId = await _seedDefaultAssets();
        // 舊交易全部歸入 Cash
        await update(transactionEntries)
            .write(TransactionEntriesCompanion(assetId: Value(cashId)));
      }
      if (from < 4) {
        // ① 加新欄(default 'grid_view')
        await m.addColumn(categories, categories.iconKey);
        // ② 用舊 codePoint 對返 key;對唔到嘅就維持 default
        for (final e in kCategoryIcons.entries) {
          await customStatement(
            'UPDATE categories SET icon_key = ? WHERE icon_code_point = ?',
            [e.key, e.value.codePoint],
          );
        }
        // ③ 刪走舊欄(需要 SQLite ≥ 3.35)
        await m.dropColumn(categories, 'icon_code_point');
      }
      if (from < 5) { // ← 加
        await m.createTable(fixedItems);
      }
      if (from < 6) {                     // ← 加
        await m.createTable(footnotes);
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