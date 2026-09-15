// month_year_panel.dart
import 'package:flutter/material.dart';

class MonthYearPanel extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onChanged;

  const MonthYearPanel({
    super.key,
    required this.initialDate,
    required this.onChanged,
  });

  @override
  State<MonthYearPanel> createState() => _MonthYearPanelState();
}

class _MonthYearPanelState extends State<MonthYearPanel> {
  late int _year;
  late int _month;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _year = widget.initialDate.year;
    _month = widget.initialDate.month;
  }

  void _pickMonth(int m) {
    setState(() => _month = m);
    widget.onChanged(DateTime(_year, m));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _year--),
              ),
              Text('$_year Year',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _year++),
              ),
              const Chip(
                label: Text('ALL'),
                backgroundColor: Colors.black,
                labelStyle: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 2.0,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(12, (i) {
              final m = i + 1;
              final selected = m == _month;
              return GestureDetector(
                onTap: () => _pickMonth(m),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? Colors.amber : Colors.white,
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Text(_months[i],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}