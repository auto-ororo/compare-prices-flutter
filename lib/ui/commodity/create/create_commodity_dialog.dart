import 'package:compare_prices/ui/common/text_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'create_commodity_dialog_view_model.dart';

class CreateCommodityDialog extends HookWidget {
  const CreateCommodityDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(createCommodityDialogViewModelProvider);
    final viewModel =
        useProvider(createCommodityDialogViewModelProvider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onCommodityCreated.stream.listen((_) {
          Navigator.pop(context);
        });
      });

      return () => {};
    }, const []);

    return TextEditDialog(
      title: "商品追加",
      labelText: "商品名",
      initialText: state.name,
      submitText: "追加",
      onTextChanged: viewModel.updateName,
      onSubmitted: viewModel.createCommodity,
    );
  }
}
