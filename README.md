# bookkeeping

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


the standard font of number and text = fontSize: 16, fontWeight: FontWeight.bold




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

