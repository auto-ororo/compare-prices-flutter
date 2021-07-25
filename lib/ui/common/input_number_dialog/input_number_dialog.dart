import 'package:compare_prices/domain/entities/number_type.dart';
import 'package:compare_prices/ui/common/input_number_dialog/input_number_dialog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InputNumberDialog extends HookWidget {
  const InputNumberDialog({
    Key? key,
    required this.title,
    required this.initialNumber,
    required this.numberType,
    this.suffix,
    this.maxNumberOfDigits = 10,
  }) : super(key: key);

  final String title;
  final int? initialNumber;
  final NumberType numberType;
  final String? suffix;
  final int maxNumberOfDigits;

  @override
  Widget build(context) {
    final provider = inputNumberDialogViewModelProvider(
      InputNumberDialogViewModelParam(
        inputtedNumber: initialNumber ?? 0,
        numberType: numberType,
        maxNumberOfDigits: maxNumberOfDigits,
      ),
    );
    final viewModel = useProvider(provider.notifier);
    final inputtedNumber =
        useProvider(provider.select((value) => value.inputtedNumber));
    final controller = useTextEditingController();

    final keySize = _getKeySize(context);

    controller.text = viewModel.convertNumberToString(context, inputtedNumber);

    return AlertDialog(
      title: Text(title),
      content: Container(
        child: Wrap(direction: Axis.horizontal, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextField(
              textAlign: TextAlign.end,
              readOnly: true,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  border: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  suffixStyle: Theme.of(context).textTheme.headline4,
                  suffixText: suffix),
              controller: controller,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["1", "2", "3"]
                .map((e) => _NumberKey(
                    label: e,
                    keySize: keySize,
                    onTap: () => viewModel.updateNumber(e)))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["4", "5", "6"]
                .map((e) => _NumberKey(
                    label: e,
                    keySize: keySize,
                    onTap: () => viewModel.updateNumber(e)))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["7", "8", "9"]
                .map((e) => _NumberKey(
                    label: e,
                    keySize: keySize,
                    onTap: () => viewModel.updateNumber(e)))
                .toList(),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _EmptyKey(keySize: keySize),
            _NumberKey(
                label: "0",
                keySize: keySize,
                onTap: () => viewModel.updateNumber("0")),
            _BackKey(keySize: keySize, onTap: viewModel.backSpace)
          ]),
        ]),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonCancel)),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(inputtedNumber);
            },
            child: Text(AppLocalizations.of(context)!.commonOk)),
      ],
    );
  }

  double _getKeySize(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final double contentSize;
    if (deviceSize.width < deviceSize.height) {
      contentSize = deviceSize.width / 5;
    } else {
      contentSize = deviceSize.height / 5;
    }
    return contentSize;
  }
}

class _KeyContainer extends StatelessWidget {
  final double keySize;
  final Function() onTap;
  final Widget? child;

  const _KeyContainer({
    Key? key,
    required this.keySize,
    required this.child,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: keySize,
      height: keySize,
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: EdgeInsets.all(8),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Center(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyKey extends StatelessWidget {
  const _EmptyKey({
    Key? key,
    required this.keySize,
  }) : super(key: key);

  final double keySize;

  @override
  Widget build(BuildContext context) {
    return _KeyContainer(
      keySize: keySize,
      child: SizedBox(
        width: 1,
        height: 1,
      ),
      onTap: () {},
    );
  }
}

class _NumberKey extends StatelessWidget {
  const _NumberKey({
    Key? key,
    required this.label,
    required this.keySize,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final double keySize;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return _KeyContainer(
      keySize: keySize,
      child: Text(
        label,
        style: Theme.of(context).textTheme.headline3,
      ),
      onTap: onTap,
    );
  }
}

class _BackKey extends StatelessWidget {
  final double keySize;
  final Function() onTap;

  const _BackKey({
    Key? key,
    required this.keySize,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _KeyContainer(
      keySize: keySize,
      child: Icon(
        Icons.backspace_outlined,
        color: Theme.of(context).textTheme.headline3!.color,
      ),
      onTap: onTap,
    );
  }
}
