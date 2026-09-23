import 'package:bookkeeping/home_page/drawer_pages/fixed_item/choose_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/category_provider.dart';
import 'package:bookkeeping/providers/asset_provider.dart';
import 'package:bookkeeping/providers/fixed_item_provider.dart';
import 'package:bookkeeping/utils/category_icon.dart';
import 'package:bookkeeping/utils/formatters.dart'; // ← 加
import 'package:bookkeeping/home_page/drawer_pages/fixed_item/fixed_item_logic.dart';
import 'package:bookkeeping/database/app_database.dart' show FixedItem; // ← 加
import 'custom_repeat_schedule_sheet.dart';
import 'repeated_times_picker_sheet.dart';
import 'asset_picker_sheet.dart'; // ← 加

class CreateANewFixedItem extends StatefulWidget {
  final FixedItem? editing; // ← 加:null = 新增,有值 = 編輯

  const CreateANewFixedItem({super.key, this.editing}); // ← 改

  @override
  State<CreateANewFixedItem> createState() => _CreateANewFixedItemState();
}

class _CreateANewFixedItemState extends State<CreateANewFixedItem> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  RepeatScheduleResult? _scheduleResult;
  int? _repeatedTimes;
  int? _selectedCategoryId;
  int? _selectedAssetId; // ← 加
  bool _isExpenseSelected = true;
  bool _saving = false;

  @override
  void initState() { // ← 加成個 initState:editing 模式要 prefill 返所有欄位
    super.initState();
    final e = widget.editing;
    if (e == null) return;
    _nameController.text = e.label;
    _amountController.text = fmtAmount(e.amount);
    _isExpenseSelected = e.isExpense;
    _selectedCategoryId = e.categoryId;
    _selectedAssetId = e.assetId;
    _repeatedTimes = e.repeatedTimes;

    final days = FixedItemLogic.scheduleDaysFromString(e.scheduleDays);
    switch (e.frequencyType) {
      case 0:
        _scheduleResult = RepeatScheduleResult(
          frequency: RepeatFrequency.weekly,
          selectedWeekdays: days.toSet(),
          selectedMonthDays: const {},
        );
      case 1:
        _scheduleResult = RepeatScheduleResult(
          frequency: RepeatFrequency.monthly,
          selectedWeekdays: const {},
          selectedMonthDays: days.toSet(),
        );
      case 2:
        _scheduleResult = RepeatScheduleResult(
          frequency: RepeatFrequency.annually,
          selectedWeekdays: const {},
          selectedMonthDays: const {},
          annualDate: days.isEmpty ? null : FixedItemLogic.decodeAnnualDay(days.first),
        );
    }
  }

  // ← 加:將 _scheduleResult 轉做 (frequencyType, scheduleDays),save 同顯示 label 兩邊共用
  (int, List<int>) get _scheduleFrequencyAndDays {
    final result = _scheduleResult;
    if (result == null) return (0, const []);
    switch (result.frequency) {
      case RepeatFrequency.weekly:
        return (0, result.selectedWeekdays.toList());
      case RepeatFrequency.monthly:
        return (1, result.selectedMonthDays.toList());
      case RepeatFrequency.annually:
        return (2, result.annualDate == null ? [] : [FixedItemLogic.encodeAnnualDay(result.annualDate!)]);
    }
  }

  String get _scheduleLabel { // ← 改:刪走原本喺呢度嘅重複邏輯,改用 FixedItemLogic
    if (_scheduleResult == null) return 'Tap to set';
    final (freq, days) = _scheduleFrequencyAndDays;
    return FixedItemLogic.scheduleLabel(freq, days);
  }

  String _repeatedTimesLabel(int? value) => value == null ? 'Unlimited' : '$value';

  Future<void> _openScheduleSheet() async {
    final result = await showModalBottomSheet<RepeatScheduleResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomRepeatScheduleSheet(
        initialFrequency: _scheduleResult?.frequency ?? RepeatFrequency.weekly,
        initialWeekdays: _scheduleResult?.selectedWeekdays ?? const {},
        initialMonthDays: _scheduleResult?.selectedMonthDays ?? const {},
        initialAnnualDate: _scheduleResult?.annualDate, // ← 加
      ),
    );
    if (result == null) return;
    setState(() => _scheduleResult = result);
  }

  Future<void> _openRepeatedTimesPicker() async {
    final result = await showRepeatedTimesPicker(context: context, initialValue: _repeatedTimes, maxTimes: 99);
    setState(() => _repeatedTimes = result);
  }

  Future<void> _openChooseCategory() async {
    final result = await Navigator.push<({int id, bool isExpense})>(
      context,
      MaterialPageRoute(builder: (context) => ChooseCategory(initialIsExpense: _isExpenseSelected)),
    );
    if (result == null) return;
    setState(() {
      _selectedCategoryId = result.id;
      _isExpenseSelected = result.isExpense;
    });
  }

  Future<void> _openAssetPicker() async { // ← 加
    final assets = context.read<AssetProvider>().activeAssets;
    final result = await showAssetPickerSheet(context: context, assets: assets, initialAssetId: _selectedAssetId);
    if (result == null) return;
    setState(() => _selectedAssetId = result);
  }

  Future<void> _savePressed() async {
    if (_saving) return;
    if (_scheduleResult == null) return;

    final (frequencyType, scheduleDays) = _scheduleFrequencyAndDays;
    final assetId = _selectedAssetId ?? context.read<AssetProvider>().defaultAssetId;

    final draft = FixedItemLogic.buildDraft(
      name: _nameController.text,
      amountText: _amountController.text,
      isExpense: _isExpenseSelected,
      categoryId: _selectedCategoryId,
      assetId: assetId,
      frequencyType: frequencyType,
      scheduleDays: scheduleDays,
      repeatedTimes: _repeatedTimes,
    );
    if (draft == null) return;

    _saving = true;
    try {
      final provider = context.read<FixedItemProvider>();
      if (widget.editing == null) {
        await provider.addFixedItem(draft);
      } else {
        await provider.updateFixedItem(widget.editing!.id, draft); // ← 加
      }
    } finally {
      _saving = false;
    }
    if (!mounted) return;
    Navigator.pop(context);
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Expanded(child: TextField(controller: _nameController, decoration: const InputDecoration(hintText: 'Tap to enter the name'))),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Expanded(child: TextField(controller: _amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '\$ 0'))),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: _openChooseCategory,
                        child: Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, _) {
                            final cat = _selectedCategoryId == null ? null : categoryProvider.categoryById(_selectedCategoryId!);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat?.label ?? (_isExpenseSelected ? 'Expense' : 'Income'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 5),
                                Icon(cat == null ? Icons.emoji_transportation : categoryIconData(cat.iconKey), size: 28),
                                const Icon(Icons.keyboard_arrow_right),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding( // ← 加成個 block:Account
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: _openAssetPicker,
                        child: Consumer<AssetProvider>(
                          builder: (context, assetProvider, _) {
                            final asset = _selectedAssetId == null ? null : assetProvider.assetById(_selectedAssetId!);
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(asset?.name ?? 'Tap to set', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 5),
                                const Icon(Icons.keyboard_arrow_right),
                              ],
                            );
                          },
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Schedule time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: _openScheduleSheet,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_scheduleLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 5),
                            const Icon(Icons.keyboard_arrow_right),
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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Repeated times', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      GestureDetector(
                        onTap: _openRepeatedTimesPicker,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12, width: 1)),
                              child: Text(_repeatedTimesLabel(_repeatedTimes), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_right, color: Colors.black54, size: 24),
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
            backgroundColor: const Color(0xFFFBC02D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: const BorderSide(color: Colors.black, width: 2.0),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: _savePressed,
          child: const Text('Confirm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
    );
  }
}