import 'package:flutter/material.dart';

class CustomCategories extends StatefulWidget {
  const  CustomCategories({super.key});

  @override
  State<CustomCategories> createState() => _CustomCategoriesState();
}

class _CustomCategoriesState extends State<CustomCategories> {
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
                      itemBuilder: (context, index) =>
                          Icon(categoryItems[index], size: 32),
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
          onPressed: () {},
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
