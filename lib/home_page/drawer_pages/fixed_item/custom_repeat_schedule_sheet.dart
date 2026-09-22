import 'package:flutter/material.dart';

/// Which tab of the repeat schedule is active.
enum RepeatFrequency { weekly, monthly, annually }

/// The result handed back when the user taps the checkmark.
class RepeatScheduleResult {
  final RepeatFrequency frequency;
  final Set<int> selectedWeekdays; // 1 = Mon ... 7 = Sun
  final Set<int> selectedMonthDays; // 1 ... 31

  const RepeatScheduleResult({
    required this.frequency,
    required this.selectedWeekdays,
    required this.selectedMonthDays,
  });
}

/// Recreates the "Custom repeat schedule" sheet:
/// - segmented Weekly / Monthly / Annually control at the top
/// - Weekly: Mon–Sun rows + a "Select all" shortcut
/// - Monthly: Day 1–31 rows
/// - Annually: premium-locked placeholder (shown with the diamond icon,
///   since the screenshots don't reveal its unlocked content)
///
/// Usage:
///   final result = await showModalBottomSheet<RepeatScheduleResult>(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => const CustomRepeatScheduleSheet(),
///   );
class CustomRepeatScheduleSheet extends StatefulWidget {
  final RepeatFrequency initialFrequency;
  final Set<int> initialWeekdays;
  final Set<int> initialMonthDays;
  final bool isPremiumUser;

  const CustomRepeatScheduleSheet({
    super.key,
    this.initialFrequency = RepeatFrequency.weekly,
    this.initialWeekdays = const {},
    this.initialMonthDays = const {},
    this.isPremiumUser = false,
  });

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

  @override
  void initState() {
    super.initState();
    _frequency = widget.initialFrequency;
    _selectedWeekdays = {...widget.initialWeekdays};
    _selectedMonthDays = {...widget.initialMonthDays};
  }

  void _confirm() {
    Navigator.of(context).pop(
      RepeatScheduleResult(
        frequency: _frequency,
        selectedWeekdays: _selectedWeekdays,
        selectedMonthDays: _selectedMonthDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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

  // Close icon — title — confirm checkmark, with a divider underneath.
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
            child: Text(
              'Custom repeat schedule',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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

  // Weekly / Monthly / Annually segmented toggle.
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
            _segment('Annually', RepeatFrequency.annually,
                icon: Icons.diamond_outlined, locked: !widget.isPremiumUser),
          ],
        ),
      ),
    );
  }

  Widget _segment(String label, RepeatFrequency value,
      {IconData? icon, bool locked = false}) {
    final selected = _frequency == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _frequency = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          color: selected ? _selectedSegmentColor : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
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
        return _buildAnnuallyLocked();
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
            child: Text(
              'Select all',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < 7; i++)
          _selectableRow(
            label: _weekdayLabels[i],
            selected: _selectedWeekdays.contains(i + 1),
            onTap: () => setState(() {
              final day = i + 1;
              _selectedWeekdays.contains(day)
                  ? _selectedWeekdays.remove(day)
                  : _selectedWeekdays.add(day);
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
              _selectedMonthDays.contains(day)
                  ? _selectedMonthDays.remove(day)
                  : _selectedMonthDays.add(day);
            }),
          ),
      ],
    );
  }

  Widget _buildAnnuallyLocked() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.diamond_outlined, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Annual scheduling is a premium feature',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // A single day/weekday row. Selected = filled orange pill + check.
  // Unselected = plain bold text, no background.
  Widget _selectableRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              if (selected)
                const Icon(Icons.check, size: 24, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}