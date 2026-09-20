import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookkeeping/providers/asset_provider.dart';

class AddANewAssetCard extends StatefulWidget {
  const AddANewAssetCard({super.key});

  @override
  State<AddANewAssetCard> createState() => _AddANewAssetCardState();
}

class _AddANewAssetCardState extends State<AddANewAssetCard> {

  final TextEditingController _newAssetName = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  bool _saving = false;

  Future<void> _confirm() async {
    if (_saving) return;
    final name = _newAssetName.text.trim();
    if (name.isEmpty) return;
    final amountText = _amount.text.trim().replaceAll(',', '');
    final initial = amountText.isEmpty ? 0.0 : double.tryParse(amountText);
    if (initial == null) return; // ⚠️ 數字打錯 → 靜雞雞唔儲(同 Calculator 一致)
    _saving = true;
    try {
      await context
          .read<AssetProvider>()
          .addAsset(name: name, initialBalance: initial);
    } finally {
      _saving = false;
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _newAssetName.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new asset'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
          children: [
            AssetCardEditor(controller: _newAssetName, typeHitText: 'Tap to enter the name'),
            AssetCardEditor(controller: _amount, typeHitText: 'Amount')
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
          onPressed: _confirm,
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


class AssetCardEditor extends StatefulWidget {

  final String typeHitText;
  final TextEditingController controller;

  const AssetCardEditor({
    super.key,
    required this.controller,
    required this.typeHitText,
  });

  @override
  State<AssetCardEditor> createState() => _AssetCardEditorState();
}

class _AssetCardEditorState extends State<AssetCardEditor> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: widget.typeHitText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
