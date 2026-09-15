import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// 仿 Smoney 中間嗰個「窿仔」圓形圖（黃色=支出，藍色=收入），
/// 中心疊字顯示 Balance。用 fl_chart 個 PieChart，
/// 靠住 centerSpaceRadius 整出中間嘅窿，再用 Stack 疊返個 Text 落去。
///
/// pubspec.yaml 記得加: fl_chart: ^0.68.0 (版本自行對返最新)
class TestPage extends StatelessWidget {
  final double expense;
  final double income;
  final double balance;
  final double size;

  const TestPage({
    super.key,
    required this.expense,
    required this.income,
    required this.balance,
    this.size = 260,
  });

  @override
  Widget build(BuildContext context) {
    // fl_chart 會按 value 比例自動分配圓弧角度，唔使自己計 %
    final sections = <PieChartSectionData>[
      PieChartSectionData(
        value: expense <= 0 ? 0.0001 : expense, // 避免全部 0 時整唔到圖
        color: const Color(0xFFFBC02D), // 黃色
        showTitle: false,
        radius: 36,
      ),
      PieChartSectionData(
        value: income <= 0 ? 0.0001 : income,
        color: const Color(0xFF42A5F5), // 藍色
        showTitle: false,
        radius: 36,
      ),
    ];

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              // 呢個數值愈大，中間個窿愈大 —— 想整到成張圖好似"轉盤"咁就靠佢
              centerSpaceRadius: size * 0.32,
              startDegreeOffset: -90, // 由12點鐘方向開始畫
              borderData: FlBorderData(show: false),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Balance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(width: 4),
                  Icon(Icons.visibility_outlined, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '\$${balance.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}





















/*   //呢度係用作展示以後每一次我在任何頁面點選嗰啲icon 或者叫Categories icon的時候，被點選嘅形態(即使其顏色嘅擺位方式)
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
       child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. 底層：黃色圓形背景（刻意偏移）
            Positioned(
              bottom: -3,   // 向下偏移
              right: -2,    // 向右偏移
              child: Container(
                width: 24,   // 圓形大細
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.amber,   // 到時會根據不同頁面而用不同的顏色，但現時用此顏色先
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // 2. 上層：透明背景嘅圖標
            const Icon(
              Icons.restaurant,   // 你嘅膳食圖標
              size: 36,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

 */

