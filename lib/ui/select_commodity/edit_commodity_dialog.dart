import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'edit_commodity_dialog_view_model.dart';

class EditCommodityDialog extends HookWidget {
  final Commodity commodity;

  const EditCommodityDialog({Key? key, required this.commodity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider =
        editCommodityDialogViewModelProvider(this.commodity.copyWith());
    final state = useProvider(provider);

    final viewModel = useProvider(provider.notifier);
    final textEditingController =
        useTextEditingController(text: state.commodity.name);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onCommodityUpdated.stream.listen((commodity) {
          Navigator.pop(context, commodity);
        });
      });

      return () => {};
    }, const []);

    return AlertDialog(
      title: Text("編集"),
      content: TextField(
        decoration: const InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            labelText: "商品名"),
        controller: textEditingController,
        onChanged: viewModel.updateName,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("キャンセル")),
        TextButton(
            onPressed: () {
              viewModel.updateCommodity();
            },
            child: const Text("更新")),
      ],
    );
  }
}
