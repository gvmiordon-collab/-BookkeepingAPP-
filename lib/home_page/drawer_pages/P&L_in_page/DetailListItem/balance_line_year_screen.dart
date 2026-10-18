import 'package:flutter/material.dart';
import 'pnl_colors.dart';
import 'pnl_logic.dart';
import 'pnl_shared_widgets.dart';
import 'pnl_widgets.dart';

/// 逐月版:範圍(MTH / Last 6 / Year)入面每個月一個點
class BalanceLineYearScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final PnlReport report; // ← 加:數據
  final int timeFilterIndex;
  final ValueChanged<int> onTimeFilterChanged;
  final String dateText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const BalanceLineYearScreen({
    super.key,
    this.onToggle,
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
          selectedColor: kPink,
        ),
        DateCurrencySelector(
          dateText: dateText,
          onPrevious: onPrevious,
          onNext: onNext,
        ),
        PnlBalanceSummary( // ← 改:原本寫死 -9,540.8 / 7,792 / -1,748.8
          report: report,
          onToggle: onToggle,
          toggleIcon: Icons.show_chart,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PnlLineView(series: report.monthly, leftReservedSize: 50), // ← 改:原本寫死 spots
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: PnlDetailsBox( // ← 改:原本寫死四行 Column
            title: 'Date',
            scrollable: true,
            rows: pnlDateRows(report.monthly),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}