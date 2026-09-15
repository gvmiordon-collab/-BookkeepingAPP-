import 'package:flutter/material.dart';

class FixedItemsModel extends StatefulWidget {

  final String fixedItemsName;
  final String categoryName;

  const FixedItemsModel({
    super.key,
    required this.fixedItemsName,
    required this.categoryName,
  });

  @override
  State<FixedItemsModel> createState() => _FixedItemsModelState();
}

class _FixedItemsModelState extends State<FixedItemsModel> {
  bool _isOn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.directions_transit_sharp),
              SizedBox(width: 8), // icon 和文字之間的間距
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 文字靠左對齊
                  mainAxisSize: MainAxisSize.min,               // 讓 Column 高度貼合內容
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.fixedItemsName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '\$ 14.8',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text( widget.categoryName + ' - Weekly / Sat - Unlimited'),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Switch(
                value: _isOn,
                onChanged: (v) => setState(() => _isOn = v),
                activeColor: Colors.white,
                activeTrackColor: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
