// lib/providers/asset_provider.dart
import 'dart:async';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:bookkeeping/database/app_database.dart';

class AssetProvider extends ChangeNotifier {
  final AppDatabase _db;
  StreamSubscription<List<AssetAccount>>? _assetSub;
  StreamSubscription<List<TransactionEntry>>? _txSub;

  List<AssetAccount> _assets = [];

  /// assetId -> 該帳戶所有交易嘅淨額(收入 − 支出)。
  /// 餘額唔另存入 DB,每次由 initialBalance + 呢個淨額計出嚟,唔會同交易對唔到數。
  Map<int, double> _netByAsset = {};

  AssetProvider(this._db) {
    _assetSub = _db.select(_db.assets).watch().listen((rows) {
      // ⚠️ 明確按 id 排(即係開戶先後),「第一個帳戶」就係 id 最細嗰個
      _assets = [...rows]..sort((a, b) => a.id.compareTo(b.id));
      notifyListeners();
    });

    _txSub = _db.select(_db.transactionEntries).watch().listen((rows) {
      final net = <int, double>{};
      for (final t in rows) {
        final id = t.assetId;
        if (id == null) continue; // 冇帳戶嘅交易唔計入任何帳戶
        net[id] = (net[id] ?? 0) + (t.isExpense ? -t.amount : t.amount);
      }
      _netByAsset = net;
      notifyListeners();
    });
  }

  // ---------- 查詢 ----------

  /// 全部帳戶(包括封存)
  List<AssetAccount> get assets => _assets;

  /// 未封存帳戶 —— 俾 Calculator 選單、Home / Asset 頁用
  List<AssetAccount> get activeAssets =>
      _assets.where((a) => !a.isArchived).toList();

  List<AssetAccount> get archivedAssets =>
      _assets.where((a) => a.isArchived).toList();

  AssetAccount? assetById(int id) {
    for (final a in _assets) {
      if (a.id == id) return a;
    }
    return null;
  }

  /// Calculator 新增交易嘅默認帳戶 = 第一個未封存帳戶。
  /// 完全冇帳戶 → null(唔會 crash,交易 assetId 存 null)。
  int? get defaultAssetId {
    final list = activeAssets;
    return list.isEmpty ? null : list.first.id;
  }

  double _round2(double v) => double.parse(v.toStringAsFixed(2));

  /// 帳戶餘額 = initialBalance + 收入 − 支出(該帳戶全部交易,唔跟月份)
  double balanceOf(int assetId) {
    final a = assetById(assetId);
    if (a == null) return 0;
    return _round2(a.initialBalance + (_netByAsset[assetId] ?? 0));
  }

  /// Total Balance = 全部帳戶加總(⚠️ 包括封存咗嗰啲)。係計算值,唔係 DB row。
  double get totalBalance =>
      _round2(_assets.fold(0.0, (sum, a) => sum + balanceOf(a.id)));

  /// Home / Asset Cards 頁用:第一張 Total Balance,之後係各個未封存帳戶
  List<({String name, double balance})> get displayCards => [
    (name: 'Total Balance', balance: totalBalance),
    for (final a in activeAssets) (name: a.name, balance: balanceOf(a.id)),
  ];

  // ---------- CRUD ----------

  Future<void> addAsset({
    required String name,
    double initialBalance = 0,
  }) {
    return _db.into(_db.assets).insert(
      AssetsCompanion.insert(
        name: name,
        initialBalance: Value(initialBalance),
      ),
    );
  }

  Future<void> updateAsset(AssetAccount asset) {
    return _db.update(_db.assets).replace(asset);
  }

  /// 跟 category 一致:
  /// 冇交易用過 → 真刪;有交易 → 封存(isArchived = true),舊交易同記錄原封不動
  Future<void> deleteAsset(int id) async {
    final inUse = await (_db.select(_db.transactionEntries)
      ..where((t) => t.assetId.equals(id))
      ..limit(1))
        .get();

    if (inUse.isEmpty) {
      await (_db.delete(_db.assets)..where((tbl) => tbl.id.equals(id))).go();
    } else {
      await (_db.update(_db.assets)..where((tbl) => tbl.id.equals(id)))
          .write(const AssetsCompanion(isArchived: Value(true)));
    }
  }

  Future<void> restoreAsset(int id) {
    return (_db.update(_db.assets)..where((tbl) => tbl.id.equals(id)))
        .write(const AssetsCompanion(isArchived: Value(false)));
  }

  @override
  void dispose() {
    _assetSub?.cancel();
    _txSub?.cancel();
    super.dispose();
  }
}