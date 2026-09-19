import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookkeeping/utils/formatters.dart';

class DateButton extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const DateButton({super.key, required this.date, required this.onChanged});

  @override
  State<DateButton> createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) widget.onChanged(picked);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            //color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        GestureDetector( // 前一日
                          onTap: () => widget.onChanged(DateTime(
                              widget.date.year, widget.date.month, widget.date.day - 1)),
                          child: const Icon(
                            Icons.arrow_left,
                            fontWeight: FontWeight.bold,
                            size: 30,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          fontWeight: FontWeight.bold,
                          size: 23,
                        ),
                        Flexible( // ⚠️ 見下面假設 4
                          child: AutoSizeText(
                            fmtDateButton(widget.date),
                            maxLines: 1,
                            minFontSize: 12,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        GestureDetector( // 後一日
                          onTap: () => widget.onChanged(DateTime(
                              widget.date.year, widget.date.month, widget.date.day + 1)),
                          child: const Icon(
                            Icons.arrow_right,
                            fontWeight: FontWeight.bold,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
