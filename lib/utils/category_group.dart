// lib/utils/category_group.dart(新檔案)
import 'package:flutter/material.dart' show Color;

/// Category 分類(group)註冊表:DB 存 key(String),顏色由 group 話事。
/// 所以一個 category 嘅顏色會跟住佢嘅 group 去晒 app 所有地方(Calculator、P&L...)。
///
/// - ⚠️ key 一經寫入 DB 就唔好改名(改咗舊資料會 fallback 去 Other)。
/// - ⚠️ 顏色全部係 placeholder(淨係 Food & drink 用返 kPink、Shopping 用返 kOrange),
///   想改色只改呢度,唔使 migration。
/// - ⚠️ Income 嘅 group 你未講過,我暫時擺咗 Salary / Investment / Other,可以自己改。
class CategoryGroup {
  final String key;
  final String label;
  final Color color;
  const CategoryGroup(this.key, this.label, this.color);
}

const String kDefaultGroupKey = 'other';

const List<CategoryGroup> kExpenseGroups = [
  CategoryGroup('food_drink', 'Food & drink', Color(0xFFEE4976)),
  CategoryGroup('shopping', 'Shopping', Color(0xFFFF9800)),
  CategoryGroup('entertainment', 'Entertainment', Color(0xFF8E5FD6)),
  CategoryGroup('transportation', 'Transportation', Color(0xFF1E9BAE)),
  CategoryGroup('basic_commodities', 'Basic commodities', Color(0xFF6DB33F)),
  CategoryGroup('education', 'Education', Color(0xFF3F7FE0)),
  CategoryGroup('medical', 'Medical', Color(0xFFE53935)),
  CategoryGroup('digital_items', 'Digital items', Color(0xFF5C6BC0)),
  CategoryGroup('other', 'Other', Color(0xFF8A8A8A)),
];

const List<CategoryGroup> kIncomeGroups = [
  CategoryGroup('salary', 'Salary', Color(0xFF29B6F6)),
  CategoryGroup('investment', 'Investment', Color(0xFF43A047)),
  CategoryGroup('other', 'Other', Color(0xFF8A8A8A)),
];

/// 當前 Expense / Income 可以揀嘅 group(次序 = 畫面次序)
List<CategoryGroup> groupsFor(bool isExpense) =>
    isExpense ? kExpenseGroups : kIncomeGroups;

/// key 揾 group;對唔到 → fallback 去 Other(灰色)
CategoryGroup categoryGroupByKey(String key) {
  for (final g in kExpenseGroups) {
    if (g.key == key) return g;
  }
  for (final g in kIncomeGroups) {
    if (g.key == key) return g;
  }
  return kExpenseGroups.last;
}

/// 全 app 攞 category 顏色就用呢個:categoryColorForGroup(category.groupKey)
Color categoryColorForGroup(String key) => categoryGroupByKey(key).color;