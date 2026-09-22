import 'package:bookkeeping/home_page/drawer_pages/fixed_item/choose_category.dart';
import 'package:flutter/material.dart';
import 'custom_repeat_schedule_sheet.dart';
import 'repeated_times_picker_sheet.dart';

class CreateANewFixedItem extends StatefulWidget {
  const CreateANewFixedItem({super.key});

  @override
  State<CreateANewFixedItem> createState() => _CreateANewFixedItemState();
}

class _CreateANewFixedItemState extends State<CreateANewFixedItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  RepeatScheduleResult? _scheduleResult;
  int? _repeatedTimes;

  static const _weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String get _scheduleLabel {
    final result = _scheduleResult;
    if (result == null) return 'Tap to set';

    switch (result.frequency) {
      case RepeatFrequency.weekly:
        final days = result.selectedWeekdays.toList()..sort();
        if (days.isEmpty) return 'Weekly';
        return 'Weekly / ${days.map((d) => _weekdayShort[d - 1]).join(', ')}';
      case RepeatFrequency.monthly:
        final days = result.selectedMonthDays.toList()..sort();
        if (days.isEmpty) return 'Monthly';
        return 'Monthly / ${days.map(_ordinal).join(', ')}';
      case RepeatFrequency.annually:
        return 'Annually';
    }
  }

  String _repeatedTimesLabel(int? value) => value == null ? 'Unlimited' : '$value';

  String _ordinal(int n) {
    if (n >= 11 && n <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  Future<void> _openScheduleSheet() async {
    final result = await showModalBottomSheet<RepeatScheduleResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomRepeatScheduleSheet(
        initialFrequency: _scheduleResult?.frequency ?? RepeatFrequency.weekly,
        initialWeekdays: _scheduleResult?.selectedWeekdays ?? const {},
        initialMonthDays: _scheduleResult?.selectedMonthDays ?? const {},
      ),
    );

    // User closed with the X instead of confirming — keep the old value.
    if (result == null) return;

    setState(() => _scheduleResult = result);
  }

  Future<void> _openRepeatedTimesPicker() async {
    final result = await showRepeatedTimesPicker(
      context: context,
      initialValue: _repeatedTimes,
      maxTimes: 99, // 可自由調整最大限制次數
    );

    // 如果用家沒有按 Confirm 而是直接滑走，result 會回傳原本的數值，所以直接更新即可
    setState(() => _repeatedTimes = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Tap to enter the name',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '\$ 0',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseCategory(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Expense',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.emoji_transportation,
                              size: 28,
                            ),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Schedule time',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: _openScheduleSheet,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _scheduleLabel,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // --- Repeated times ---
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10), // 微調內邊距
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Repeated times',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: _openRepeatedTimesPicker,
                        behavior: HitTestBehavior.opaque, // 擴大點擊感應範圍
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 格式化後的小標籤 (Badge)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100, // 淺灰背景
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _repeatedTimesLabel(_repeatedTimes),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black54,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
              minimumSize: Size(double.infinity, 50)),
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