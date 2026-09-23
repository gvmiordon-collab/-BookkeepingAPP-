import 'package:bookkeeping/home_page/drawer_pages/fixed_item/fixed_items_model.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/home_page/drawer_pages/fixed_item/add_a_new_fixed_item.dart';
import 'package:provider/provider.dart'; // ← 加
import 'package:bookkeeping/providers/fixed_item_provider.dart'; // ← 加
import 'package:bookkeeping/providers/category_provider.dart'; // ← 加
import 'package:bookkeeping/home_page/drawer_pages/fixed_item/fixed_item_logic.dart'; // ← 加
import 'package:bookkeeping/utils/formatters.dart'; // ← 加

class FixedItemPages extends StatefulWidget {
  const FixedItemPages({super.key});

  @override
  State<FixedItemPages> createState() => _FixedItemPagesState();
}

class _FixedItemPagesState extends State<FixedItemPages> {
  // ← 刪走原本嗰兩個假 list(fixedItemsName / categoryName)

  @override
  Widget build(BuildContext context) {
    final items = context.watch<FixedItemProvider>().items; // ← 加
    final categoryProvider = context.watch<CategoryProvider>(); // ← 加

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Income/Expense'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: items.length, // ← 改
        itemBuilder: (BuildContext context, int index) {
          final item = items[index]; // ← 加
          final category = categoryProvider.categoryById(item.categoryId); // ← 加
          return FixedItemsModel(
            fixedItemsId: item.id,
            fixedItemsName: item.label,
            categoryName: category?.label ?? '',
            categoryIconKey: category?.iconKey,
            amountText: fmtAmount(item.amount, grouped: true),
            isExpense: item.isExpense,
            scheduleLabel: FixedItemLogic.scheduleLabel(
              item.frequencyType,
              FixedItemLogic.scheduleDaysFromString(item.scheduleDays),
            ),
            repeatedTimesLabel: FixedItemLogic.repeatedTimesLabel(item.repeatedTimes),
            isActive: item.isActive,
            onActiveChanged: (v) => context.read<FixedItemProvider>().setActive(item.id, v),
            onDelete: () => context.read<FixedItemProvider>().deleteFixedItem(item.id),
            onLongPress: () => Navigator.push( // ← 加
              context,
              MaterialPageRoute(builder: (context) => CreateANewFixedItem(editing: item)),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange[300],
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
          elevation: 5,
          side: const BorderSide(color: Colors.black, width: 2.0),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateANewFixedItem()));
        },
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}