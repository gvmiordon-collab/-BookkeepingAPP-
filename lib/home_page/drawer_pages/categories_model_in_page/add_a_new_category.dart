import 'package:flutter/material.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/widgets/selectable_category_icon.dart';
import 'package:bookkeeping/widgets/category_group_selector.dart'; // ← 加
import 'package:provider/provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/utils/category_group.dart'; // ← 加

class CustomCategories extends StatefulWidget {
  final bool isExpense;
  const  CustomCategories({super.key, required this.isExpense});

  @override
  State<CustomCategories> createState() => _CustomCategoriesState();

}

class _CustomCategoriesState extends State<CustomCategories> {

  // ⚠️ 改:預設揀第一個 icon(跟樣辦,名稱欄一開始就有 icon),原本係 null
  int? _selectedIconIndex = 0; // 用 index 唔用 codePoint，因為 list 而家有重複 icon，唔會出現一齊被揀中

  // ← 加:揀咗邊個 group(決定顏色)。預設第一個(Food & drink / Salary)
  late String _groupKey = groupsFor(widget.isExpense).first.key;

  bool _saving = false;

  Future<void> _confirm() async {
    if (_saving) return;
    final name = _newCategoryName.text.trim();
    if (name.isEmpty || _selectedIconIndex == null) return;
    _saving = true;
    try {
      await context.read<CategoryProvider>().addCategory(
        label: name,
        iconKey: categoryItems[_selectedIconIndex!],
        groupKey: _groupKey, // ← 加
        isExpense: widget.isExpense,
      );
    } finally {
      _saving = false;
    }
    if (!mounted) return;
    Navigator.pop(context);
  }


  final TextEditingController _newCategoryName = TextEditingController();

  @override
  void dispose() {
    _newCategoryName.dispose();
    super.dispose();
  }

  final List<String> categoryItems = [
    for (var i = 0; i < 3; i++) ...[
      'restaurant', 'transit', 'shopping_bag', 'grid_view', 'grid_view',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final groupColor = categoryColorForGroup(_groupKey); // ← 加
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('Add a new category'),
        centerTitle: true,
      ),
      // ⚠️ 改:Padding → SingleChildScrollView(加咗 group 區之後,矮啲嘅螢幕會 overflow),
      // 底部留 90 俾浮動嘅 Confirm 掣,唔會遮住個 icon grid
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // ← 改:原本 Icon(Icons.add)。而家顯示當前揀咗嘅 icon + group 顏色圓形墊
                    SelectableCategoryIcon(
                      icon: categoryIconData(categoryItems[_selectedIconIndex ?? 0]),
                      size: 28,
                      selected: true,
                      highlightColor: groupColor,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _newCategoryName,
                        decoration: InputDecoration(
                          hintText: 'Tap to enter the name',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // ← 加:分類(group)揀掣區
            CategoryGroupSelector(
              groups: groupsFor(widget.isExpense),
              selectedKey: _groupKey,
              onChanged: (k) => setState(() => _groupKey = k),
            ),
            SizedBox(
              height: 10,
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                const crossAxisCount = 4;
                const spacing = 10.0;
                const hPadding = 40.0;   // GridView 左右 padding
                const vPadding = 20.0;   // GridView 上下 padding
                const rows = 3;          // 想顯示幾行

                // 每格寬度
                final cellWidth =
                    (constraints.maxWidth - hPadding - spacing * (crossAxisCount - 1))
                        / crossAxisCount;

                // 總高度 = 格高 × 行數 + 間距 + padding
                final gridHeight =
                    cellWidth * rows + spacing * (rows - 1) + vPadding;

                return SizedBox(
                  height: gridHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 3),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: hPadding / 2, vertical: vPadding / 2),
                      itemCount: categoryItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _selectedIconIndex = index),
                        child: Center( // ⚠️ 一定要有 Center,否則 Stack 會撐滿成個格,圓形會跑去格仔右下角而唔係 icon 右下角
                          child: SelectableCategoryIcon(
                            icon: categoryIconData(categoryItems[index]),
                            size: 32,
                            selected: index == _selectedIconIndex,
                            highlightColor: groupColor, // ← 加:圓形墊跟 group 顏色
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFBC02D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              minimumSize: Size(double.infinity,50)
          ),
          onPressed: _confirm,
          child: Text(
            'Confirm',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}