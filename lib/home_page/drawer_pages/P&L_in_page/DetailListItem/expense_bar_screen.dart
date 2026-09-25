import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pnl_colors.dart';
import 'pnl_shared_widgets.dart';

class ExpenseBarScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final int timeFilterIndex; // ← 加
  final ValueChanged<int> onTimeFilterChanged; // ← 加

  const ExpenseBarScreen({
    super.key,
    this.onToggle,
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
          selectedColor: kYellow,
        ),
        DateCurrencySelector(
          dateText: '2026',
          onPrevious: () {},
          onNext: () {},
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 10),
            child: onToggle != null
                ? IconButton(
              icon: const Icon(Icons.pie_chart_outline),
              onPressed: onToggle,
            )
                : const Icon(Icons.pie_chart_outline),
          ),
        ),
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const texts = ['Shopping', 'Food & drink', 'Transportation'];
                        if (value.toInt() >= 0 && value.toInt() < texts.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(texts[value.toInt()], style: const TextStyle(fontSize: 10)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(left: BorderSide(), bottom: BorderSide())),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 0, color: kYellow, width: 30)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 80.3, color: kPink, width: 30)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 19.7, color: kBlue, width: 30)]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
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
                const DetailListItem(icon: Icons.circle, iconBgColor: kPink, title: 'Food & drink', amount: '\$7,665.6'),
                const DetailListItem(icon: Icons.circle, iconBgColor: kBlue, title: 'Transportation', amount: '\$1,875.2'),
                const DetailListItem(icon: Icons.circle, iconBgColor: kYellow, title: 'Shopping', amount: '\$0'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}