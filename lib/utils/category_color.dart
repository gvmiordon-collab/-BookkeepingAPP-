import 'package:flutter/material.dart' show Color;

/// Category 自動配色:Expense/Income 各自一條 10 色序列,唔重複,
/// 新增 category 嗰陣跟現有同類型數量 round-robin 派色(用完轉頭再用)。
/// ⚠️ 呢批全部係隨便揀嘅 placeholder 顏色,等 user 遲啲拍板實際想要邊套。
const List<Color> kExpenseCategoryColors = [
  Color(0xFFE53935), // red
  Color(0xFFFB8C00), // orange
  Color(0xFFFDD835), // yellow
  Color(0xFF7CB342), // light green
  Color(0xFF00897B), // teal
  Color(0xFF039BE5), // light blue
  Color(0xFF5E35B1), // deep purple
  Color(0xFFD81B60), // pink
  Color(0xFF6D4C41), // brown
  Color(0xFF757575), // grey
];

const List<Color> kIncomeCategoryColors = [
  Color(0xFF1E88E5), // blue
  Color(0xFF43A047), // green
  Color(0xFF8E24AA), // purple
  Color(0xFF00ACC1), // cyan
  Color(0xFF3949AB), // indigo
  Color(0xFFC0CA33), // lime
  Color(0xFF546E7A), // blue grey
  Color(0xFFFFB300), // amber
  Color(0xFFF4511E), // deep orange
  Color(0xFFAD1457), // magenta
];

/// colorIndex 存喺 DB(唔存實際色值),色板日後想換都唔使 migration。
Color categoryColorForIndex(int colorIndex, bool isExpense) {
  final palette = isExpense ? kExpenseCategoryColors : kIncomeCategoryColors;
  return palette[colorIndex % palette.length];
}