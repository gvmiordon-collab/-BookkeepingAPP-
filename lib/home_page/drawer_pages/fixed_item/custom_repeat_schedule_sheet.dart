import 'package:flutter/material.dart';

enum RepeatFrequency { weekly, monthly, annually }

class RepeatScheduleResult {
  final RepeatFrequency frequency;
  final Set<int> selectedWeekdays;
  final Set<int> selectedMonthDays;
  final DateTime? annualDate; // ← 加

  const RepeatScheduleResult({
    required this.frequency,
    required this.selectedWeekdays,
    required this.selectedMonthDays,
    this.annualDate, // ← 加
  });
}

class CustomRepeatScheduleSheet extends StatefulWidget {
  final RepeatFrequency initialFrequency;
  final Set<int> initialWeekdays;
  final Set<int> initialMonthDays;
  final DateTime? initialAnnualDate; // ← 加

  const CustomRepeatScheduleSheet({
    super.key,
    this.initialFrequency = RepeatFrequency.weekly,
    this.initialWeekdays = const {},
    this.initialMonthDays = const {},
    this.initialAnnualDate, // ← 加
  });
  // ← 刪:isPremiumUser 唔再需要,Annually 而家一律解鎖

  @override
  State<CustomRepeatScheduleSheet> createState() =>
      _CustomRepeatScheduleSheetState();
}

class _CustomRepeatScheduleSheetState
    extends State<CustomRepeatScheduleSheet> {
  static const _selectedPillColor = Color(0xFFFFC94D);
  static const _selectedSegmentColor = Color(0xFF4FC3F7);
  static const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  late RepeatFrequency _frequency;
  late Set<int> _selectedWeekdays;
  late Set<int> _selectedMonthDays;
  late DateTime? _selectedAnnualDate; // ← 加

  @override
  void initState() {
    super.initState();
    _frequency = widget.initialFrequency;
    _selectedWeekdays = {...widget.initialWeekdays};
    _selectedMonthDays = {...widget.initialMonthDays};
    _selectedAnnualDate = widget.initialAnnualDate; // ← 加
  }

  void _confirm() {
    Navigator.of(context).pop(
      RepeatScheduleResult(
        frequency: _frequency,
        selectedWeekdays: _selectedWeekdays,
        selectedMonthDays: _selectedMonthDays,
        annualDate: _selectedAnnualDate, // ← 加
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black, width: 2.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildSegmentedControl(),
          Flexible(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Custom repeat schedule', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          IconButton(
            icon: const Icon(Icons.check, size: 28),
            onPressed: _confirm,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _segment('Weekly', RepeatFrequency.weekly),
            _segment('Monthly', RepeatFrequency.monthly),
            _segment('Annually', RepeatFrequency.annually), // ← 改:原本仲有 icon: diamond, locked: true
          ],
        ),
      ),
    );
  }

  Widget _segment(String label, RepeatFrequency value) { // ← 改:刪走 icon/locked 兩個參數
    final selected = _frequency == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _frequency = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          color: selected ? _selectedSegmentColor : Colors.white,
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_frequency) {
      case RepeatFrequency.weekly:
        return _buildWeeklyList();
      case RepeatFrequency.monthly:
        return _buildMonthlyList();
      case RepeatFrequency.annually:
        return _buildAnnuallyCalendar(); // ← 改:原本 _buildAnnuallyLocked()
    }
  }

  Widget _buildWeeklyList() {
    final allSelected = _selectedWeekdays.length == 7;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        GestureDetector(
          onTap: () => setState(() {
            _selectedWeekdays = allSelected ? {} : {1, 2, 3, 4, 5, 6, 7};
          }),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Select all',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade600)),
          ),
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < 7; i++)
          _selectableRow(
            label: _weekdayLabels[i],
            selected: _selectedWeekdays.contains(i + 1),
            onTap: () => setState(() {
              final day = i + 1;
              _selectedWeekdays.contains(day) ? _selectedWeekdays.remove(day) : _selectedWeekdays.add(day);
            }),
          ),
      ],
    );
  }

  Widget _buildMonthlyList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        for (var day = 1; day <= 31; day++)
          _selectableRow(
            label: 'Day $day',
            selected: _selectedMonthDays.contains(day),
            onTap: () => setState(() {
              _selectedMonthDays.contains(day) ? _selectedMonthDays.remove(day) : _selectedMonthDays.add(day);
            }),
          ),
      ],
    );
  }

  // ← 改:原本 _buildAnnuallyLocked(),而家換成真係月曆
  Widget _buildAnnuallyCalendar() {
    return CalendarDatePicker(
      initialDate: _selectedAnnualDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      onDateChanged: (d) => setState(() => _selectedAnnualDate = d),
    );
  }

  Widget _selectableRow({required String label, required bool selected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: selected ? _selectedPillColor : Colors.transparent,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              if (selected) const Icon(Icons.check, size: 24, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}