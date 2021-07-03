import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/common/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'update_shop_dialog_view_model.dart';

class UpdateShopDialog extends HookWidget {
  final Shop shop;

  const UpdateShopDialog({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(context) {
    final provider = updateShopDialogViewModelProvider(this.shop);
    final shop = useProvider(provider.select((value) => value.shop));

    final viewModel = useProvider(provider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onShopUpdated.stream.listen((shop) {
          Navigator.pop(context, shop);
        });
      });

      return () => {};
    }, const []);

    return TextEditDialog(
      title: "店舗編集",
      initialText: shop.name,
      labelText: "店舗名",
      submitText: "更新",
      onTextChanged: viewModel.updateName,
      onSubmitted: viewModel.updateShop,
    );
  }
}
