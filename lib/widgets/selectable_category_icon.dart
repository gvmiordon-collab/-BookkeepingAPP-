import 'package:flutter/material.dart';

/// Categories icon 嘅選中狀態:黃色圓形墊喺 icon 右下角(刻意偏移),icon 疊喺上面。
/// 樣式跟 test_page 嗰個範例,圓形大細同偏移量按 size 等比縮放
/// (test 範例:icon 36 → 圓 24、bottom -3、right -2)。
class SelectableCategoryIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool selected;
  final Color highlightColor; // 將來每頁想用唔同顏色,傳呢個就得

  const SelectableCategoryIcon({
    super.key,
    required this.icon,
    required this.size,
    this.selected = false,
    this.highlightColor = const Color(0xFFFBC02D),
  });

  @override
  Widget build(BuildContext context) {
    final circle = size * 2 / 3;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none, // 圓形會伸出 icon 範圍外面,唔加會被切走
      children: [
        if (selected)
          Positioned(
            bottom: -size / 12,
            right: -size / 18,
            child: Container(
              width: circle,
              height: circle,
              decoration: BoxDecoration(
                color: highlightColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        Icon(icon, size: size),
      ],
    );
  }
}