import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerDialog extends HookWidget {
  const NumberPickerDialog({
    Key? key,
    required this.title,
    required this.minimum,
    required this.maximum,
    required this.initialNumber,
    this.unitText,
  }) : super(key: key);

  final String title;
  final int minimum;
  final int maximum;
  final int initialNumber;
  final String? unitText;

  @override
  Widget build(context) {
    final selectedNumber = useState(initialNumber);
    return AlertDialog(
      title: Text(title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: NumberPicker(
              minValue: minimum,
              maxValue: maximum,
              value: selectedNumber.value,
              onChanged: (v) => {selectedNumber.value = v},
            ),
          ),
          Text(
            unitText ?? "",
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("キャンセル")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(selectedNumber.value);
            },
            child: Text("OK")),
      ],
    );
  }
}
