import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField(
      {Key? key,
      this.controller,
      required this.onChanged,
      this.labelText,
      this.hintText})
      : super(key: key);

  final TextEditingController? controller;
  final Function(String) onChanged;
  final String? labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          labelText: labelText,
          hintText: hintText),
      controller: controller,
      onChanged: onChanged,
    );
  }
}
