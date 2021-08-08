import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ShowDialogExtension on Widget {
  Future<T?> showConfirmDialog<T>(
      {required BuildContext context,
      required String message,
      required Function() onOk}) {
    return showDialog<T>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.commonConfirm),
            content: Text(message),
            actions: [
              // ボタン領域
              TextButton(
                  child: Text(AppLocalizations.of(context)!.commonCancel),
                  onPressed: () async {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text(AppLocalizations.of(context)!.commonOk),
                onPressed: () async {
                  await onOk();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
