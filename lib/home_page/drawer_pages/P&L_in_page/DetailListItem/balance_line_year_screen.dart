import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pnl_colors.dart';
import 'pnl_shared_widgets.dart';

class BalanceLineYearScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final int timeFilterIndex; // ← 加
  final ValueChanged<int> onTimeFilterChanged; // ← 加

  const BalanceLineYearScreen({
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
          dateText: '2026',
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
                    TextSpan(text: '-9,540.8', style: TextStyle(color: kYellow, fontWeight: FontWeight.bold)),
                  ])),
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Income '),
                    TextSpan(text: '7,792', style: TextStyle(color: kBlue, fontWeight: FontWeight.bold)),
                  ])),
                ],
              ),
              Row(
                children: [
                  RichText(text: const TextSpan(style: TextStyle(color: Colors.black, fontSize: 16), children: [
                    TextSpan(text: 'Balance '),
                    TextSpan(text: '-1,748.8', style: TextStyle(color: kPink, fontWeight: FontWeight.bold)),
                  ])),
                  if (onToggle != null)
                    IconButton(
                      icon: const Icon(Icons.show_chart),
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
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const texts = ['Mar', 'Jun', 'Sep']; // 舊→新
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
                  LineChartBarData(spots: const [FlSpot(0, -100), FlSpot(1, -100), FlSpot(2, 900)], isCurved: false, color: kPink, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 500), FlSpot(1, 500), FlSpot(2, 900)], isCurved: false, color: kBlue, dotData: const FlDotData(show: true)),
                  LineChartBarData(spots: const [FlSpot(0, 1000), FlSpot(1, 1000), FlSpot(2, 300)], isCurved: false, color: kYellow, dotData: const FlDotData(show: true)),
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
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Sep', amount: '\$689.6'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Aug', amount: '\$-1,097.4'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Jul', amount: '\$-1,171.8'),
                const DetailListItem(icon: Icons.calendar_today, iconBgColor: Colors.transparent, title: 'Jun', amount: '\$-464'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}