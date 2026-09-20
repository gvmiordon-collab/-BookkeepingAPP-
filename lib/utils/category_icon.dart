// lib/utils/category_icon.dart(成個覆蓋原本嗰個)
import 'package:flutter/material.dart' show Icons, IconData;

/// 分類 icon 註冊表:DB 存 key(String),顯示時用 key 對返 IconData。
///
/// - 全部 IconData 都係 const(直接引用 Icons.xxx),所以 release build 做 icon tree-shake 冇問題。
/// - ⚠️ key 一經寫入 DB 就唔好改名(改咗舊資料會變返 fallback icon)。
/// - 想加新 icon:只管喺下面加 entry,唔使 migration。
const String kDefaultCategoryIconKey = 'grid_view';

const Map<String, IconData> kCategoryIcons = {
  'restaurant': Icons.restaurant,
  'transit': Icons.directions_transit_sharp,
  'shopping_bag': Icons.shopping_bag_outlined,
  'grid_view': Icons.grid_view_outlined,
  'payments': Icons.payments_outlined,
};

/// key 對唔到(例如將來刪咗某個 icon)→ fallback 去 grid_view
IconData categoryIconData(String key) =>
    kCategoryIcons[key] ?? Icons.grid_view_outlined;