import 'package:flutter/material.dart';

class PickerFormField extends StatelessWidget {
  const PickerFormField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        enableInteractiveSelection: false,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          labelText: labelText,
        ),
        onTap: onTap);
  }
}
