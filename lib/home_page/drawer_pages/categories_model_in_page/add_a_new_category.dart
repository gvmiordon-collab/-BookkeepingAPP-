import 'package:flutter/material.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/widgets/selectable_category_icon.dart';
import 'package:provider/provider.dart';


class CustomCategories extends StatefulWidget {
  final bool isExpense;
  const  CustomCategories({super.key, required this.isExpense});

  @override
  State<CustomCategories> createState() => _CustomCategoriesState();

}

class _CustomCategoriesState extends State<CustomCategories> {

  // State 入面加：
  int? _selectedIconIndex; // 用 index 唔用 codePoint，因為 list 而家有重複 icon，唔會出現一齊被揀中

  Future<void> _confirm() async {
    final name = _newCategoryName.text.trim();
    if (name.isEmpty || _selectedIconIndex == null) return; // ⚠️ 見下面
    await context.read<CategoryProvider>().addCategory(
      label: name,
      iconCodePoint: categoryItems[_selectedIconIndex!].codePoint,
      isExpense: widget.isExpense,
    );
    if (!mounted) return;
    Navigator.pop(context);
  }


  final TextEditingController _newCategoryName = TextEditingController();

  @override
  void dispose() {
   _newCategoryName.dispose();
   super.dispose();
  }

  final List<IconData> categoryItems = [  //遲啲引入整個Icon Library 比User 慢慢揀
     Icons.restaurant,
     Icons.directions_transit_sharp,
     Icons.shopping_bag_outlined,
     Icons.grid_view_outlined,
     Icons.grid_view_outlined,
    Icons.restaurant,
    Icons.directions_transit_sharp,
    Icons.shopping_bag_outlined,
    Icons.grid_view_outlined,
    Icons.grid_view_outlined,
    Icons.restaurant,
    Icons.directions_transit_sharp,
    Icons.shopping_bag_outlined,
    Icons.grid_view_outlined,
    Icons.grid_view_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('Add a new category'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    Icon(
                        Icons.add,
                    ),
                    SizedBox(
                      width: 5,
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
                            icon: categoryItems[index],
                            size: 32,
                            selected: index == _selectedIconIndex,
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
