import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextEditDialog extends HookWidget {
  const TextEditDialog({
    Key? key,
    required this.title,
    this.initialText,
    this.labelText,
    this.submitText,
    this.cancelText,
    required this.onTextChanged,
    this.validator,
    required this.onSubmitted,
    this.onCanceled,
  }) : super(key: key);

  final String title;
  final String? initialText;
  final String? labelText;
  final String? submitText;
  final String? cancelText;
  final Function(String) onTextChanged;
  final String? Function()? validator;
  final Function() onSubmitted;
  final Function()? onCanceled;

  @override
  Widget build(context) {
    final TextEditingController textEditingController =
        useTextEditingController(text: initialText);

    final String? Function() v;

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    if (validator != null) {
      v = validator!;
    } else {
      v = () {
        return textEditingController.text.isEmpty ? "入力して下さい" : null;
      };
    }

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              labelText: labelText),
          controller: textEditingController,
          onChanged: onTextChanged,
          validator: (_) {
            return v();
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (onCanceled != null) {
                onCanceled!();
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(cancelText ?? "キャンセル")),
        TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                onSubmitted();
              }
            },
            child: Text(submitText ?? "更新")),
      ],
    );
  }
}
