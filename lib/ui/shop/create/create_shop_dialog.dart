import 'package:compare_prices/ui/common/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_shop_dialog_view_model.dart';

class CreateShopDialog extends HookWidget {
  const CreateShopDialog({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final name = useProvider(
        createShopDialogViewModelProvider.select((value) => value.name));
    final viewModel = useProvider(createShopDialogViewModelProvider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onShopCreated.stream.listen((_) {
          Navigator.pop(context);
        });
      });

      return () => {};
    }, const []);

    return TextEditDialog(
      title: "店舗追加",
      labelText: "店舗名",
      submitText: "追加",
      initialText: name,
      onTextChanged: viewModel.updateName,
      onSubmitted: viewModel.createShop,
    );
  }
}
