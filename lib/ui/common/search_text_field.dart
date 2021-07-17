import 'package:compare_prices/ui/assets/color/app_colors.dart';
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
          filled: true,
          fillColor: AppColors.note,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.transparent)),
          contentPadding: const EdgeInsets.all(8),
          // labelText: labelText,
          hintText: hintText),
      controller: controller,
      onChanged: onChanged,
    );
  }
}
