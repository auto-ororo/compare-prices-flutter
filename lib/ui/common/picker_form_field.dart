import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PickerFormField extends HookWidget {
  const PickerFormField(
      {Key? key,
      required this.labelText,
      required this.text,
      required this.onTap,
      this.textAlign,
      this.validator})
      : super(key: key);

  final String text;
  final TextAlign? textAlign;
  final String labelText;
  final Function() onTap;
  final Function()? validator;

  @override
  Widget build(context) {
    final controller = useTextEditingController(text: text);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        controller.text = text;
      });
    }, [text]);

    return TextFormField(
        readOnly: true,
        textAlign: textAlign ?? TextAlign.start,
        enableInteractiveSelection: false,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
          labelText: labelText,
        ),
        validator: (_) {
          if (validator != null) {
            return validator!();
          }
        },
        onTap: onTap);
  }
}
