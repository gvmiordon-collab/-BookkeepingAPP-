import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Value returned by the picker.
/// `null` means "Unlimited". Otherwise it's the chosen repeat count.
typedef RepeatedTimesResult = int?;

/// Shows the "Repeated times" picker as a bottom sheet, matching the
/// Smoney-style layout: title bar -> wheel picker -> orange Confirm button.
///
/// Usage:
///   final result = await showRepeatedTimesPicker(
///     context: context,
///     initialValue: currentRepeatedTimes, // null = Unlimited
///   );
///   if (result != _unset) setState(() => repeatedTimes = result);
Future<RepeatedTimesResult> showRepeatedTimesPicker({
  required BuildContext context,
  RepeatedTimesResult initialValue,
  int maxTimes = 99,
}) async {
  final result = await showModalBottomSheet<RepeatedTimesResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => RepeatedTimesPickerSheet(
      initialValue: initialValue,
      maxTimes: maxTimes,
    ),
  );
  // If the user dismissed without confirming, treat as "no change".
  return result ?? initialValue;
}

class RepeatedTimesPickerSheet extends StatefulWidget {
  const RepeatedTimesPickerSheet({
    super.key,
    this.initialValue,
    this.maxTimes = 99,
  });

  /// null = "Unlimited"
  final int? initialValue;
  final int maxTimes;

  @override
  State<RepeatedTimesPickerSheet> createState() =>
      _RepeatedTimesPickerSheetState();
}

class _RepeatedTimesPickerSheetState extends State<RepeatedTimesPickerSheet> {
  // Row 0 = "Unlimited", rows 1..maxTimes = 1..maxTimes.
  late final FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialValue == null ? 0 : widget.initialValue!;
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? get _currentValue => _selectedIndex == 0 ? null : _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Repeated times',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black87),

            // Wheel picker
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                scrollController: _controller,
                itemExtent: 44,
                useMagnifier: true,
                magnification: 1.15,
                selectionOverlay: Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.black26, width: 1),
                    ),
                  ),
                ),
                onSelectedItemChanged: (index) {
                  setState(() => _selectedIndex = index);
                },
                children: [
                  _PickerLabel(text: 'Unlimited', selected: _selectedIndex == 0),
                  for (var n = 1; n <= widget.maxTimes; n++)
                    _PickerLabel(text: '$n', selected: _selectedIndex == n),
                ],
              ),
            ),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF7C05A),
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () => Navigator.of(context).pop(_currentValue),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerLabel extends StatelessWidget {
  const _PickerLabel({required this.text, required this.selected});

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          color: selected ? Colors.black : Colors.black54,
        ),
      ),
    );
  }
}

/// --- Example of wiring it into the "Add an item" form field ---
///
/// String repeatedTimesLabel(int? value) => value == null ? 'Unlimited' : '$value';
///
/// InkWell(
///   onTap: () async {
///     final result = await showRepeatedTimesPicker(
///       context: context,
///       initialValue: repeatedTimes, // int? field on your form state
///     );
///     setState(() => repeatedTimes = result);
///   },
///   child: FormFieldRow(
///     label: 'Repeated times',
///     value: repeatedTimesLabel(repeatedTimes),
///   ),
/// )