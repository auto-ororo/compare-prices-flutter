import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ShowDialogExtension on Widget {
  Future<T?> showConfirmDialog<T>(
      {required BuildContext context,
      String? title,
      required String message,
      required Function() onOk,
      Function()? onCancel}) {
    return showDialog<T>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title ?? AppLocalizations.of(context)!.commonConfirm),
            content: Text(message),
            actions: [
              // ボタン領域
              TextButton(
                  child: Text(AppLocalizations.of(context)!.commonCancel),
                  onPressed: () async {
                    if (onCancel != null) {
                      await onCancel();
                    }
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
