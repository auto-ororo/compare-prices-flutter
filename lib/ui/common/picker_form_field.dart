import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PickerFormField extends HookWidget {
  const PickerFormField({
    Key? key,
    required this.labelText,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final String labelText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: text);

    useEffect(() {
      controller.text = text;
    }, [text]);

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
