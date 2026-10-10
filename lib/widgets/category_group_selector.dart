// lib/widgets/category_group_selector.dart(新檔案)
import 'package:flutter/material.dart';
import 'package:bookkeeping/utils/category_group.dart';

/// Add a new category 頁嘅「分類」揀掣區:pill 形掣,揀中嗰個填 group 顏色 + 白字。
/// 純畫面,冇邏輯:揀咗邊個就 call onChanged(groupKey)。
class CategoryGroupSelector extends StatelessWidget {
  final List<CategoryGroup> groups;
  final String selectedKey;
  final ValueChanged<String> onChanged;

  const CategoryGroupSelector({
    super.key,
    required this.groups,
    required this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween, // 每行左右分散,跟樣辦一樣參差
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final g in groups) _pill(g),
        ],
      ),
    );
  }

  Widget _pill(CategoryGroup g) {
    final selected = g.key == selectedKey;
    return GestureDetector(
      onTap: () => onChanged(g.key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? g.color : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          g.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}