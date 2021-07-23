import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextEditDialog extends HookWidget {
  TextEditDialog({
    Key? key,
    required this.title,
    this.initialText,
    this.labelText,
    this.errorText,
    this.submitText,
    this.cancelText,
    required this.onTextChanged,
    required this.onSubmitted,
    this.onCanceled,
  }) : super(key: key);

  final String title;
  final String? initialText;
  final String? labelText;
  final String? errorText;
  final String? submitText;
  final String? cancelText;
  final Function(String) onTextChanged;
  final Function() onSubmitted;
  final Function()? onCanceled;

  @override
  Widget build(context) {
    final TextEditingController textEditingController =
        useTextEditingController(text: initialText);

    final validationErrorText = useState<String?>(null);

    final String? Function() v;

    final _formKey = useMemoized(() => GlobalKey<FormState>());

    v = () {
      validationErrorText.value = textEditingController.text.isEmpty
          ? AppLocalizations.of(context)!.commonInputHint
          : null;

      return validationErrorText.value;
    };

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
              errorText: validationErrorText.value ?? errorText,
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
            child:
                Text(cancelText ?? AppLocalizations.of(context)!.commonCancel)),
        TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                onSubmitted();
              }
            },
            child:
                Text(submitText ?? AppLocalizations.of(context)!.commonUpdate)),
      ],
    );
  }
}
