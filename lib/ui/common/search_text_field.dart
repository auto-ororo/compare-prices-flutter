import 'package:flutter/cupertino.dart';
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
  Widget build(context) {
    return TextField(
      decoration: InputDecoration(
          isDense: true,
          border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          hintText: hintText),
      controller: controller,
      onChanged: onChanged,
    );
  }
}
