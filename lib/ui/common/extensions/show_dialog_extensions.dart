import 'package:flutter/material.dart';

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
            title: Text(title ?? "確認"),
            content: Text(message),
            actions: [
              // ボタン領域
              TextButton(
                  child: Text("Cancel"),
                  onPressed: () async {
                    if (onCancel != null) {
                      await onCancel();
                    }
                    Navigator.pop(context);
                  }),
              TextButton(
                child: Text("OK"),
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
