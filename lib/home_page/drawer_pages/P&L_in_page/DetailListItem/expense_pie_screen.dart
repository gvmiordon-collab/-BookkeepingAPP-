import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'pnl_colors.dart';
import 'pnl_shared_widgets.dart';

class ExpensePieScreen extends StatelessWidget {
  final VoidCallback? onToggle;
  final int timeFilterIndex; // ← 加
  final ValueChanged<int> onTimeFilterChanged; // ← 加

  const ExpensePieScreen({
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
          onPrevious: () {}, // TODO:等傾清楚「上一個」點計先駁
          onNext: () {},
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    SizedBox(
                      height: 220,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                              sections: [
                                PieChartSectionData(color: kPink, value: 80.3, showTitle: false, radius: 40, borderSide: const BorderSide(color: Colors.black, width: 2)),
                                PieChartSectionData(color: kYellow, value: 19.7, showTitle: false, radius: 40, borderSide: const BorderSide(color: Colors.black, width: 2)),
                              ],
                            ),
                          ),
                          const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Total expense', style: TextStyle(fontSize: 14, color: Colors.black87)),
                                Text('\$9,540.8', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onToggle != null)
                      IconButton(
                        icon: const Icon(Icons.bar_chart),
                        onPressed: onToggle,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildLegend(kPink, '膳食  80.3%'),
                          const SizedBox(width: 20),
                          _buildLegend(kYellow, 'Trasp...  19.7%'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLegend(kOrange, 'Snacks  0%'),
                        ],
                      ),
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
                      const DetailListItem(icon: Icons.restaurant, iconBgColor: kPink, title: '膳食', amount: '\$7,665.6'),
                      const DetailListItem(icon: Icons.directions_bus, iconBgColor: kYellow, title: 'Trasportations', amount: '\$1,875.2'),
                      const DetailListItem(icon: Icons.shopping_bag_outlined, iconBgColor: kOrange, title: 'Snacks', amount: '\$0'),
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