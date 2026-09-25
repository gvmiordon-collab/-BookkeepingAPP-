import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pnl_colors.dart';
import 'pnl_shared_widgets.dart';

class BalanceLineScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final int timeFilterIndex; // ← 加
  final ValueChanged<int> onTimeFilterChanged; // ← 加

  const BalanceLineScreen({
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
          selectedColor: kPink,
        ),
        DateCurrencySelector(
          dateText: 'Sep 2026',
          onPrevious: () {},
          onNext: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Expense '),
                    TextSpan(text: '-210.4', style: TextStyle(color: kYellow, fontWeight: FontWeight.bold)),
                  ])),
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Income '),
                    TextSpan(text: '900', style: TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
                  ])),
                ],
              ),
              Row(
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Balance '),
                    TextSpan(text: '689.6', style: TextStyle(color: kPink, fontWeight: FontWeight.bold)),
                  ])),
                  if (onToggle != null)
                    IconButton(
                      icon: const Icon(Icons.auto_graph),
                      onPressed: onToggle,
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const texts = ['Sep 1', 'Sep 3', 'Sep 5', 'Sep 20']; // 舊→新
                        if (value.toInt() >= 0 && value.toInt() < texts.length) {
                          return Text(texts[value.toInt()], style: const TextStyle(fontSize: 10));
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true, border: const Border(left: BorderSide(), bottom: BorderSide())),
                lineBarsData: [
                  LineChartBarData(spots: const [FlSpot(0, 10), FlSpot(1, 10), FlSpot(2, 880), FlSpot(3, 0)], isCurved: false, color: kPink, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 20), FlSpot(1, 20), FlSpot(2, 880), FlSpot(3, 0)], isCurved: false, color: kBlue, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 50), FlSpot(1, 50), FlSpot(2, 20), FlSpot(3, 0)], isCurved: false, color: kYellow, dotData: const FlDotData(show: true)),
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
                      Text('Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Icon(Icons.sort, size: 20),
                    ],
                  ),
                ),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 20', amount: '\$-6'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 8', amount: '\$0'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 5', amount: '\$885.2'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep 4', amount: '\$-47.4'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}