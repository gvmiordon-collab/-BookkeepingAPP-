import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pnl_colors.dart';
import 'pnl_shared_widgets.dart';

class IncomePieScreen extends StatelessWidget {
  final int timeFilterIndex; // ← 加
  final ValueChanged<int> onTimeFilterChanged; // ← 加

  const IncomePieScreen({
    super.key,
    required this.timeFilterIndex,
    required this.onTimeFilterChanged,
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
          dateText: '2026',
          onPrevious: () {},
          onNext: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          sections: [
                            PieChartSectionData(color: kBlue, value: 100, showTitle: false, radius: 40, borderSide: const BorderSide(color: Colors.black, width: 2)),
                          ],
                        ),
                      ),
                      const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Total income', style: TextStyle(fontSize: 14, color: Colors.black87)),
                            Text('\$7,792', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildLegend(kBlue, 'Salary  100%'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Icon(Icons.sort, size: 20),
                          ],
                        ),
                      ),
                      const DetailListItem(icon: Icons.account_balance_wallet, iconBgColor: kBlue, title: 'Salary', amount: '\$7,792'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}