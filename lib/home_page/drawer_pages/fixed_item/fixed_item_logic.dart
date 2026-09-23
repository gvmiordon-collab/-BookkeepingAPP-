// lib/home_page/drawer_pages/fixed_item/fixed_item_logic.dart
// 純 Dart(唔 import Flutter):frequency/schedule 計算 + 撳 Confirm 嗰陣嘅驗證規則。
// 跟 calculator_logic.dart 同一套模式 —— 畫面淨係收集輸入,規則全部喺呢度。

class FixedItemDraft {
  final String label;
  final double amount;
  final bool isExpense;
  final int categoryId;
  final int? assetId;
  final int frequencyType; // 0 weekly, 1 monthly
  final List<int> scheduleDays;
  final int? repeatedTimes;

  const FixedItemDraft({
    required this.label,
    required this.amount,
    required this.isExpense,
    required this.categoryId,
    required this.assetId,
    required this.frequencyType,
    required this.scheduleDays,
    required this.repeatedTimes,
  });
}

class FixedItemLogic {
  FixedItemLogic._();

  static const _weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _monthShort = [ // ← 加
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String scheduleDaysToString(List<int> days) => (List.of(days)..sort()).join(',');

  static List<int> scheduleDaysFromString(String s) =>
      s.isEmpty ? [] : s.split(',').map(int.parse).toList();

  // ← 加:Annually 冇「第幾個」呢種概念,淨係用月+日,包做一個 int(3月5日 → 305)存入 scheduleDays
  static int encodeAnnualDay(DateTime d) => d.month * 100 + d.day;

  static DateTime decodeAnnualDay(int encoded, {int year = 2000}) =>
      DateTime(year, encoded ~/ 100, encoded % 100);

  /// 'Weekly / Mon, Wed' / 'Monthly / 1st, 15th' / 'Tap to set'(冇揀日)
  static String scheduleLabel(int frequencyType, List<int> days) {
    if (days.isEmpty) return 'Tap to set';
    if (frequencyType == 2) { // ← 加
      final d = decodeAnnualDay(days.first);
      return 'Annually / ${_monthShort[d.month - 1]} ${d.day.toString().padLeft(2, '0')}';
    }
    final sorted = List.of(days)..sort();
    if (frequencyType == 0) {
      return 'Weekly / ${sorted.map((d) => _weekdayShort[d - 1]).join(', ')}';
    }
    return 'Monthly / ${sorted.map(_ordinal).join(', ')}';
  }

  static String _ordinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    switch (n % 10) {
      case 1: return '${n}st';
      case 2: return '${n}nd';
      case 3: return '${n}rd';
      default: return '${n}th';
    }
  }

  static String repeatedTimesLabel(int? value) => value == null ? 'Unlimited' : '$value';

  /// 撳 Confirm 嗰陣嘅驗證:
  /// - 名/金額打錯、冇揀分類、冇揀 schedule → null(唔儲)
  /// ⚠️ 靜雞雞唔儲,唔彈 error,跟 Calculator 個慣例一致
  static FixedItemDraft? buildDraft({
    required String name,
    required String amountText,
    required bool isExpense,
    required int? categoryId,
    required int? assetId,
    required int frequencyType,
    required List<int> scheduleDays,
    required int? repeatedTimes,
  }) {
    final label = name.trim();
    if (label.isEmpty) return null;
    if (categoryId == null) return null;
    if (scheduleDays.isEmpty) return null;
    final amount = double.tryParse(amountText.trim().replaceAll(',', ''));
    if (amount == null || amount < 0) return null;

    return FixedItemDraft(
      label: label,
      amount: amount,
      isExpense: isExpense,
      categoryId: categoryId,
      assetId: assetId,
      frequencyType: frequencyType,
      scheduleDays: scheduleDays,
      repeatedTimes: repeatedTimes,
    );
  }

  /// 揾返 (start, exclusive] 到 (end, inclusive] 之間啱 schedule 嘅日子。
  /// ⚠️ Monthly 揀咗嘅日子如果嗰個月冇(例如 31 號但二月冇)就直接 skip 嗰個月。
  static List<DateTime> dueDatesInRange({
    required int frequencyType,
    required List<int> scheduleDays,
    required DateTime start,
    required DateTime end,
  }) {
    final result = <DateTime>[];
    var cursor = DateTime(start.year, start.month, start.day).add(const Duration(days: 1));
    final last = DateTime(end.year, end.month, end.day);
    final daySet = scheduleDays.toSet();
    final annualEncoded = frequencyType == 2 && scheduleDays.isNotEmpty ? scheduleDays.first : null;
    while (!cursor.isAfter(last)) {
      final match = switch (frequencyType) { // ← 改:原本 if/else,加多個 case 2
        0 => daySet.contains(cursor.weekday),
        1 => daySet.contains(cursor.day),
        2 => annualEncoded != null && (cursor.month * 100 + cursor.day) == annualEncoded,
        _ => false,
      };
      if (match) result.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return result;
  }
}