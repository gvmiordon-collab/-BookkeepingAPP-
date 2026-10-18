import 'package:flutter/material.dart';
import 'pnl_colors.dart';
import 'pnl_logic.dart';
import 'pnl_shared_widgets.dart';
import 'pnl_widgets.dart';

class IncomePieScreen extends StatelessWidget {
  final PnlReport report; // ← 加:數據
  final int timeFilterIndex;
  final ValueChanged<int> onTimeFilterChanged;
  final String dateText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const IncomePieScreen({
    super.key,
    required this.report, // ← 加
    required this.timeFilterIndex,
    required this.onTimeFilterChanged,
    required this.dateText,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeFilterTabs(
          selectedIndex: timeFilterIndex,
          onTabSelected: onTimeFilterChanged,
          selectedColor: kBlue,
        ),
        DateCurrencySelector(
          dateText: dateText,
          onPrevious: onPrevious,
          onNext: onNext,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                PnlPieView( // ← 改:原本寫死 value 100 同 '$7,792'
                  groups: report.incomeGroups,
                  centerLabel: 'Total income',
                  total: report.totalIncome,
                ),
                const SizedBox(height: 20),
                PnlLegendBox(groups: report.incomeGroups), // ← 改:原本寫死 'Salary  100%'
                const SizedBox(height: 16),
                PnlDetailsBox( // ← 改:原本寫死一行 Salary
                  title: 'Details',
                  rows: pnlCategoryRows(report.incomeCategories),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}