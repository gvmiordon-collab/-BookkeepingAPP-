// lib/home_page/drawer_pages/P&L_in_page/DetailListItem/pnl_logic.dart(新檔案)
// 純 Dart(唔 import Flutter):P&L 頁嘅時間範圍、◀▶ 導航、加總、折線圖 series。
// 畫面淨係收 PnlReport 顯示,規則全部喺呢度(跟 calculator_logic / fixed_item_logic 同一套模式)。

import 'dart:math' as math;

/// 對應 TimeFilterTabs 嘅 index:0 MTH / 1 Last 6 / 2 Year / 3 Custom
enum PnlRangeMode { month, last6, year, custom }

/// 喂入嚟嘅交易(由畫面層從 TransactionEntry 轉)
class PnlTx {
  final DateTime date;
  final double amount;
  final bool isExpense;
  final int categoryId;

  const PnlTx({
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.categoryId,
  });
}

/// 喂入嚟嘅分類(由畫面層從 Category 轉,包括封存咗嗰啲 —— 舊交易要用)
class PnlCategory {
  final int id;
  final String label;
  final String iconKey;
  final String groupKey;

  const PnlCategory({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.groupKey,
  });
}

/// 時間範圍:[start, endExclusive),兩邊都係當日 00:00
class PnlRange {
  final DateTime start;
  final DateTime endExclusive;

  const PnlRange(this.start, this.endExclusive);

  bool contains(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return !day.isBefore(start) && day.isBefore(endExclusive);
  }
}

class PnlCategoryTotal {
  final int categoryId;
  final String label;
  final String iconKey;
  final String groupKey;
  final double total;

  const PnlCategoryTotal({
    required this.categoryId,
    required this.label,
    required this.iconKey,
    required this.groupKey,
    required this.total,
  });
}

class PnlGroupTotal {
  final String groupKey;
  final double total;
  final double percent; // 0~100,一個小數
  final List<PnlCategoryTotal> categories; // 金額大 → 細

  const PnlGroupTotal({
    required this.groupKey,
    required this.total,
    required this.percent,
    required this.categories,
  });
}

/// 折線圖 / Date 列表嘅一個點(一日或者一個月)
class PnlBucket {
  final DateTime start;
  final String label;
  final double expense; // 正數
  final double income;
  final double balance; // income − expense
  final bool hasActivity; // 呢個 bucket 有冇交易(淨額為 0 都算有)

  const PnlBucket({
    required this.start,
    required this.label,
    required this.expense,
    required this.income,
    required this.balance,
    required this.hasActivity,
  });
}

class PnlSeries {
  final List<PnlBucket> buckets; // 舊 → 新
  final double minY;
  final double maxY;
  final double maxX; // x = bucket index,minX 固定 0
  final int labelInterval; // 底部標籤每隔幾個 bucket 出一個

  const PnlSeries({
    required this.buckets,
    required this.minY,
    required this.maxY,
    required this.maxX,
    required this.labelInterval,
  });
}

class PnlReport {
  final PnlRange range;
  final double totalExpense; // 正數
  final double totalIncome;
  final double balance; // totalIncome − totalExpense
  final List<PnlGroupTotal> expenseGroups; // 金額大 → 細
  final List<PnlGroupTotal> incomeGroups;
  final List<PnlCategoryTotal> expenseCategories; // 唔分 group,全部攤平,金額大 → 細
  final List<PnlCategoryTotal> incomeCategories;
  final PnlSeries daily; // 範圍內逐日(BalanceLineScreen 用)
  final PnlSeries monthly; // 範圍內逐月(BalanceLineYearScreen 用)

  const PnlReport({
    required this.range,
    required this.totalExpense,
    required this.totalIncome,
    required this.balance,
    required this.expenseGroups,
    required this.incomeGroups,
    required this.expenseCategories,
    required this.incomeCategories,
    required this.daily,
    required this.monthly,
  });
}

class PnlLogic {
  PnlLogic._();

  static const _monthShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // ---------- 時間範圍 ----------

  static PnlRangeMode modeFromIndex(int i) =>
      PnlRangeMode.values[math.min(math.max(i, 0), PnlRangeMode.values.length - 1)];

  /// anchor = 畫面揀咗嘅「月」(日期部分唔重要)
  /// ⚠️ Last 6 = 由 anchor 嗰個月數返去,連 anchor 嗰個月共 6 個月
  /// ⚠️ Custom 未接(User 話先唔做),暫時當 MTH 處理
  static PnlRange rangeFor(PnlRangeMode mode, DateTime anchor) {
    final a = DateTime(anchor.year, anchor.month);
    switch (mode) {
      case PnlRangeMode.month:
      case PnlRangeMode.custom:
        return PnlRange(a, DateTime(a.year, a.month + 1));
      case PnlRangeMode.last6:
        return PnlRange(DateTime(a.year, a.month - 5), DateTime(a.year, a.month + 1));
      case PnlRangeMode.year:
        return PnlRange(DateTime(a.year), DateTime(a.year + 1));
    }
  }

  /// ◀ ▶ 嘅跳法:
  /// ⚠️ Year 每次跳一年(月份保持);MTH / Last 6 / Custom 每次跳一個月
  /// (Last 6 即係個 6 個月窗口逐月滑)
  static DateTime shiftAnchor(PnlRangeMode mode, DateTime anchor, int delta) {
    if (mode == PnlRangeMode.year) {
      return DateTime(anchor.year + delta, anchor.month);
    }
    return DateTime(anchor.year, anchor.month + delta);
  }

  /// DateCurrencySelector 中間嗰行字:'Sep 2026' / 'Apr - Sep 2026' / '2026'
  static String labelFor(PnlRangeMode mode, DateTime anchor) {
    final r = rangeFor(mode, anchor);
    switch (mode) {
      case PnlRangeMode.year:
        return '${r.start.year}';
      case PnlRangeMode.last6:
        final first = r.start;
        final last = DateTime(r.endExclusive.year, r.endExclusive.month - 1);
        final m1 = _monthShort[first.month - 1];
        final m2 = _monthShort[last.month - 1];
        if (first.year == last.year) return '$m1 - $m2 ${last.year}';
        return '$m1 ${first.year} - $m2 ${last.year}';
      case PnlRangeMode.month:
      case PnlRangeMode.custom:
        return '${_monthShort[r.start.month - 1]} ${r.start.year}';
    }
  }

  // ---------- 主入口 ----------

  static PnlReport buildReport({
    required PnlRangeMode mode,
    required DateTime anchor,
    required List<PnlTx> transactions,
    required List<PnlCategory> categories,
  }) {
    final range = rangeFor(mode, anchor);
    final inRange = [
      for (final t in transactions)
        if (range.contains(t.date)) t,
    ];
    final catById = {for (final c in categories) c.id: c};

    final expenseCategories = _categoryTotals(inRange, catById, isExpense: true);
    final incomeCategories = _categoryTotals(inRange, catById, isExpense: false);

    final totalExpense =
    _round2(expenseCategories.fold(0.0, (sum, c) => sum + c.total));
    final totalIncome =
    _round2(incomeCategories.fold(0.0, (sum, c) => sum + c.total));

    return PnlReport(
      range: range,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      balance: _round2(totalIncome - totalExpense),
      expenseGroups: _groupTotals(expenseCategories),
      incomeGroups: _groupTotals(incomeCategories),
      expenseCategories: expenseCategories,
      incomeCategories: incomeCategories,
      daily: _dailySeries(range, inRange),
      monthly: _monthlySeries(range, inRange),
    );
  }

  // ---------- 加總 ----------

  /// 每個 category 一行,金額大 → 細。總額 ≤ 0 嘅唔要(Pie 畫唔到)。
  static List<PnlCategoryTotal> _categoryTotals(
      List<PnlTx> txs,
      Map<int, PnlCategory> catById, {
        required bool isExpense,
      }) {
    final sums = <int, double>{};
    for (final t in txs) {
      if (t.isExpense != isExpense) continue;
      sums[t.categoryId] = (sums[t.categoryId] ?? 0) + t.amount;
    }
    final result = <PnlCategoryTotal>[];
    sums.forEach((id, sum) {
      final total = _round2(sum);
      if (total <= 0) return;
      final c = catById[id];
      result.add(PnlCategoryTotal(
        categoryId: id,
        label: c?.label ?? 'Other',
        iconKey: c?.iconKey ?? '', // 空 → categoryIconData 自動 fallback 去 grid_view
        groupKey: c?.groupKey ?? 'other',
        total: total,
      ));
    });
    result.sort((a, b) => b.total.compareTo(a.total));
    return result;
  }

  /// 將 category 按 groupKey 歸類。傳入嘅 list 已經係大 → 細,所以每組入面自然都係大 → 細。
  static List<PnlGroupTotal> _groupTotals(List<PnlCategoryTotal> cats) {
    final byGroup = <String, List<PnlCategoryTotal>>{};
    for (final c in cats) {
      byGroup.putIfAbsent(c.groupKey, () => []).add(c);
    }
    final grand = cats.fold(0.0, (sum, c) => sum + c.total);
    final groups = <PnlGroupTotal>[];
    byGroup.forEach((key, list) {
      final total = _round2(list.fold(0.0, (sum, c) => sum + c.total));
      groups.add(PnlGroupTotal(
        groupKey: key,
        total: total,
        percent: grand <= 0 ? 0.0 : _round1(total / grand * 100),
        categories: list,
      ));
    });
    groups.sort((a, b) => b.total.compareTo(a.total));
    return groups;
  }

  // ---------- 折線圖 series ----------

  static PnlSeries _dailySeries(PnlRange range, List<PnlTx> txs) {
    final n = _daysBetween(range.start, range.endExclusive);
    final exp = List<double>.filled(n, 0);
    final inc = List<double>.filled(n, 0);
    final cnt = List<int>.filled(n, 0);
    for (final t in txs) {
      final i = _daysBetween(range.start, t.date);
      if (i < 0 || i >= n) continue;
      if (t.isExpense) {
        exp[i] += t.amount;
      } else {
        inc[i] += t.amount;
      }
      cnt[i]++;
    }
    final buckets = <PnlBucket>[];
    for (var i = 0; i < n; i++) {
      final d = DateTime(range.start.year, range.start.month, range.start.day + i);
      buckets.add(_bucket(d, '${_monthShort[d.month - 1]} ${d.day}', exp[i], inc[i], cnt[i]));
    }
    return _series(buckets);
  }

  static PnlSeries _monthlySeries(PnlRange range, List<PnlTx> txs) {
    final first = DateTime(range.start.year, range.start.month);
    final lastDay = DateTime(
        range.endExclusive.year, range.endExclusive.month, range.endExclusive.day - 1);
    final n = (lastDay.year - first.year) * 12 + lastDay.month - first.month + 1;
    final exp = List<double>.filled(n, 0);
    final inc = List<double>.filled(n, 0);
    final cnt = List<int>.filled(n, 0);
    for (final t in txs) {
      final i = (t.date.year - first.year) * 12 + t.date.month - first.month;
      if (i < 0 || i >= n) continue;
      if (t.isExpense) {
        exp[i] += t.amount;
      } else {
        inc[i] += t.amount;
      }
      cnt[i]++;
    }
    final buckets = <PnlBucket>[];
    for (var i = 0; i < n; i++) {
      final d = DateTime(first.year, first.month + i);
      buckets.add(_bucket(d, _monthShort[d.month - 1], exp[i], inc[i], cnt[i]));
    }
    return _series(buckets);
  }

  static PnlBucket _bucket(DateTime start, String label, double expense, double income, int count) {
    final e = _round2(expense);
    final i = _round2(income);
    return PnlBucket(
      start: start,
      label: label,
      expense: e,
      income: i,
      balance: _round2(i - e),
      hasActivity: count > 0,
    );
  }

  static PnlSeries _series(List<PnlBucket> buckets) {
    var lo = 0.0; // Y 軸一定包住 0
    var hi = 0.0;
    for (final b in buckets) {
      for (final v in [b.expense, b.income, b.balance]) {
        lo = math.min(lo, v);
        hi = math.max(hi, v);
      }
    }
    if (hi == lo) hi = lo + 100; // 全部 0(冇數據):俾個正常嘅軸,fl_chart 先唔會 min == max
    final n = buckets.length;
    return PnlSeries(
      buckets: buckets,
      minY: lo,
      maxY: hi,
      maxX: n > 1 ? (n - 1).toDouble() : 1.0, // 得一個點都唔好 minX == maxX
      labelInterval: math.max(1, (n / 5).ceil()),
    );
  }

  // ---------- 小工具 ----------

  /// 用 UTC 計日數差,避免夏令時間轉換嗰日令 inDays 計錯(同 formatters.dart 一樣做法)
  static int _daysBetween(DateTime a, DateTime b) =>
      DateTime.utc(b.year, b.month, b.day)
          .difference(DateTime.utc(a.year, a.month, a.day))
          .inDays;

  static double _round2(double v) {
    final r = double.parse(v.toStringAsFixed(2));
    return r == 0 ? 0.0 : r; // 避免 -0.0 變 '-0'
  }

  static double _round1(double v) {
    final r = double.parse(v.toStringAsFixed(1));
    return r == 0 ? 0.0 : r;
  }
}