// lib/calculator/calculator_logic.dart
// 純 Dart(唔 import Flutter):算式計算 + 撳 OK 時嘅驗證 / 整理規則。
// CalculatorPage 只負責畫面同收集輸入,規則全部喺呢度。

import 'package:math_expressions/math_expressions.dart';

/// 整理好、可以直接交俾 TransactionProvider 儲存嘅一筆交易
class TransactionDraft {
  final DateTime date;
  final double amount;
  final bool isExpense;
  final int categoryId;
  final int? assetId;
  final String? footnote;

  const TransactionDraft({
    required this.date,
    required this.amount,
    required this.isExpense,
    required this.categoryId,
    required this.assetId,
    required this.footnote,
  });
}

class CalculatorLogic {
  CalculatorLogic._();

  /// 計算式 → 數字。語法錯 / 唔完整(例如 "5+")/ 除以 0 → 返回 null
  static double? evaluate(String expr) {
    if (expr.isEmpty) return null;
    try {
      final text = expr.replaceAll('×', '*').replaceAll('÷', '/');
      final Expression exp = GrammarParser().parse(text);
      final num result = RealEvaluator(ContextModel()).evaluate(exp);
      final value = result.toDouble();
      if (!value.isFinite) return null; // 1÷0 → Infinity / NaN
      return double.parse(value.toStringAsFixed(2)); // ⚠️ 四捨五入兩位小數
    } catch (_) {
      return null;
    }
  }

  /// 撳 OK 時嘅金額規則:
  /// - 空(乜都冇打)→ 0
  /// - 0 → 允許
  /// - 算式打錯 / 唔完整 / 負數 → null(唔儲)
  static double? amountForSave(String expr) {
    if (expr.trim().isEmpty) return 0;
    final v = evaluate(expr);
    if (v == null || v < 0) return null;
    return v;
  }

  /// 撳 OK:將用家輸入整理成一筆可以直接儲存嘅交易。
  /// 返回 null = 唔儲(算式打錯 / 負數 / 當前 Expense/Income 冇任何分類)。
  ///
  /// [availableCategoryIds]:當前 Expense/Income 未封存嘅分類 id,次序要同畫面一致。
  static TransactionDraft? buildDraft({
    required String expression,
    required DateTime date,
    required bool isExpense,
    required int? selectedCategoryId,
    required List<int> availableCategoryIds,
    required int? selectedAssetId,
    required int? defaultAssetId,
    required String footnoteText,
  }) {
    final amount = amountForSave(expression);
    if (amount == null) return null;

    // 冇揀分類 → 用畫面上排第一嘅分類
    final categoryId = selectedCategoryId ??
        (availableCategoryIds.isEmpty ? null : availableCategoryIds.first);
    if (categoryId == null) return null;

    final trimmed = footnoteText.trim();

    return TransactionDraft(
      date: DateTime(date.year, date.month, date.day),
      amount: amount,
      isExpense: isExpense,
      categoryId: categoryId,
      assetId: selectedAssetId ?? defaultAssetId, // 冇揀帳戶 → 第一個帳戶
      footnote: trimmed.isEmpty ? null : trimmed, // 冇寫 → null(列表會顯示分類名)
    );
  }
}