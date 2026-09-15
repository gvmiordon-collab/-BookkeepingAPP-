import 'package:flutter/material.dart';

class CreateANewFixedItem extends StatefulWidget {
  const CreateANewFixedItem({super.key});

  @override
  State<CreateANewFixedItem> createState() => _CreateANewFixedItemState();
}

class _CreateANewFixedItemState extends State<CreateANewFixedItem> {

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
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
              Icon(
                Icons.add,
              ),
              SizedBox(
                width: 5,
              ),
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
    );
  }
}
