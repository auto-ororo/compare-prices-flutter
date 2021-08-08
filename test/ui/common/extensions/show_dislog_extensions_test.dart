import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helper.dart';

void main() {
  group('ShowDialogExtension', () {
    final message = 'message';

    var count = 0;

    final counter = () {
      count++;
    };

    group('showConfirmDialog', () {
      testWidgets('Paramのmessage,OK押下時の処理が設定されること',
          (WidgetTester tester) async {
        count = 0;
        await tester.pumpAppWidget(
            WrapConfirmDialogWidget(message: message, onOk: () => counter()),
            []);

        final context = tester.getContext(WrapConfirmDialogWidget);

        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // ダイアログが開くことを確認
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text(message), findsOneWidget);

        // OK押下
        await tester.tap(find.text(AppLocalizations.of(context)!.commonOk));
        await tester.pumpAndSettle();

        // Paramのコールバックが呼ばれ、ダイアログが閉じることを確認
        expect(find.byType(AlertDialog), findsNothing);
        expect(count, 1);
      });

      testWidgets('キャンセル押下で閉じること', (WidgetTester tester) async {
        count = 0;
        await tester.pumpAppWidget(
            WrapConfirmDialogWidget(message: message, onOk: () => counter()),
            []);

        final context = tester.getContext(WrapConfirmDialogWidget);

        await tester.tap(find.byType(TextButton));
        await tester.pumpAndSettle();

        // ダイアログが開くことを確認
        expect(find.byType(AlertDialog), findsOneWidget);

        // キャンセル押下
        await tester.tap(find.text(AppLocalizations.of(context)!.commonCancel));
        await tester.pumpAndSettle();

        // Paramのコールバックが呼ばれずにダイアログが閉じることを確認
        expect(find.byType(AlertDialog), findsNothing);
        expect(count, 0);
      });
    });
  });
}

class WrapConfirmDialogWidget extends StatelessWidget {
  const WrapConfirmDialogWidget(
      {Key? key, required this.message, required this.onOk})
      : super(key: key);

  final Function() onOk;
  final String message;

  @override
  Widget build(context) {
    return TextButton(
        onPressed: () async =>
            showConfirmDialog(context: context, message: message, onOk: onOk),
        child: Text("showConfirmDialog"));
  }
}
