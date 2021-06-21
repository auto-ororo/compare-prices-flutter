import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/select_commodity/commodity_popup_action.dart';
import 'package:compare_prices/ui/select_commodity/select_commodity_dialog_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'edit_commodity_dialog.dart';

class SelectCommodityDialog extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(selectCommodityDialogViewModelProvider);
    final viewModel =
        useProvider(selectCommodityDialogViewModelProvider.notifier);
    final textEditingController = useTextEditingController();

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.getList();

        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onCommoditySelected.stream.listen((selectedCommodity) {
          Navigator.pop(context, selectedCommodity);
        });

        viewModel.editCommodity.stream.listen((commodity) async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return EditCommodityDialog(commodity: commodity);
              });

          viewModel.getList();
        });
      });

      return () {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        print("execute filter list");
        viewModel.filter();
      });
      return () => {};
    }, [state.searchWord, state.commodities]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品選択'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchTextField(
              controller: textEditingController,
              labelText: "商品名",
              hintText: "商品名を入力してください。",
              onChanged: (word) {
                viewModel.updateSearchWord(word);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: state.filteredCommodities.length,
                itemBuilder: (context, index) {
                  final commodity = state.filteredCommodities[index];
                  return ListTile(
                    title: Text(commodity.name),
                    onTap: () => viewModel.selectCommodity(commodity),
                    trailing: PopupMenuButton<CommodityPopupAction>(
                      onSelected: (CommodityPopupAction action) {
                        viewModel.handleCommodityPopupAction(action);
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            child: Text("編集"),
                            value: CommodityPopupAction.edit(commodity)),
                        PopupMenuItem(
                          child: Text(
                            "削除",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          value: CommodityPopupAction.delete(commodity),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

