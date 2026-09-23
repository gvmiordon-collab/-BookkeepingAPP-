import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // ← 加,跟 transactions_table.dart / assets_card.dart 一致
import 'package:bookkeeping/utils/category_icon.dart'; // ← 加

class FixedItemsModel extends StatelessWidget { // ← 改:StatefulWidget → StatelessWidget,Switch 狀態而家由 DB 話事
  final int fixedItemsId;
  final String fixedItemsName;
  final String categoryName;
  final String? categoryIconKey;
  final String amountText;
  final bool isExpense;
  final String scheduleLabel;
  final String repeatedTimesLabel;
  final bool isActive;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onDelete;
  final VoidCallback? onLongPress; // ← 加

  const FixedItemsModel({
    super.key,
    required this.fixedItemsId,
    required this.fixedItemsName,
    required this.categoryName,
    this.categoryIconKey,
    required this.amountText,
    required this.isExpense,
    required this.scheduleLabel,
    required this.repeatedTimesLabel,
    required this.isActive,
    required this.onActiveChanged,
    required this.onDelete,
    this.onLongPress, // ← 加
  });

  @override
  Widget build(BuildContext context) {
    return Slidable( // ← 加,撳嚟刪除
      key: ValueKey(fixedItemsId),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            icon: Icons.delete,
            backgroundColor: Colors.red,
          ),
        ],
      ),
      child: GestureDetector( // ← 加
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(categoryIconKey == null // ← 改:原本寫死 Icons.directions_transit_sharp
                      ? Icons.grid_view_outlined
                      : categoryIconData(categoryIconKey!)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(fixedItemsName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 5),
                            Text(
                              '${isExpense ? '-' : ''}\$ $amountText', // ← 改:原本寫死 '$ 14.8'
                              style: const TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text('$categoryName - $scheduleLabel - $repeatedTimesLabel'), // ← 改:原本寫死
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: isActive, // ← 改:原本用 local _isOn
                    onChanged: onActiveChanged, // ← 改:原本淨係 setState,冇連任何嘢
                    activeColor: Colors.white,
                    activeTrackColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}