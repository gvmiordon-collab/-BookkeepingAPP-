// lib/home_page/drawer_pages/fixed_item/asset_picker_sheet.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookkeeping/database/app_database.dart' show AssetAccount;

/// 跟 repeated_times_picker_sheet.dart 完全同一套樣:title bar -> wheel picker -> 橙色 Confirm 掣,
/// 淨係將「Unlimited / 1~99」換做戶口名。揀返 assetId。
Future<int?> showAssetPickerSheet({
  required BuildContext context,
  required List<AssetAccount> assets,
  int? initialAssetId,
}) async {
  if (assets.isEmpty) return initialAssetId;
  final result = await showModalBottomSheet<int?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AssetPickerSheet(assets: assets, initialAssetId: initialAssetId),
  );
  return result ?? initialAssetId;
}

class _AssetPickerSheet extends StatefulWidget {
  final List<AssetAccount> assets;
  final int? initialAssetId;

  const _AssetPickerSheet({required this.assets, this.initialAssetId});

  @override
  State<_AssetPickerSheet> createState() => _AssetPickerSheetState();
}

class _AssetPickerSheetState extends State<_AssetPickerSheet> {
  late final FixedExtentScrollController _controller;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    final idx = widget.initialAssetId == null
        ? 0
        : widget.assets.indexWhere((a) => a.id == widget.initialAssetId);
    _selectedIndex = idx < 0 ? 0 : idx;
    _controller = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text('Account', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black87),
            SizedBox(
              height: 200,
              child: CupertinoPicker(
                scrollController: _controller,
                itemExtent: 44,
                useMagnifier: true,
                magnification: 1.15,
                selectionOverlay: Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(color: Colors.black26, width: 1)),
                  ),
                ),
                onSelectedItemChanged: (index) => setState(() => _selectedIndex = index),
                children: [
                  for (var i = 0; i < widget.assets.length; i++)
                    _PickerLabel(text: widget.assets[i].name, selected: _selectedIndex == i),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF7C05A),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () => Navigator.of(context).pop(widget.assets[_selectedIndex].id),
                child: const Text('Confirm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
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
      child: Text(text, style: TextStyle(fontSize: 22, color: selected ? Colors.black : Colors.black54)),
    );
  }
}