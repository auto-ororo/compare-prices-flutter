import 'package:flutter/material.dart';

class RecognizableSelectedStatePopupMenuItem<T> extends PopupMenuItem<T> {
  RecognizableSelectedStatePopupMenuItem({
    required BuildContext context,
    Key? key,
    required String text,
    required T selectedValue,
    required T value,
  }) : super(
            key: key,
            child: Text(
              text,
              style: TextStyle(
                  color: selectedValue == value
                      ? Theme.of(context).primaryColor
                      : Colors.black),
            ),
            value: value);
}
