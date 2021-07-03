import 'package:compare_prices/domain/entities/commodity_sort_type.dart';
import 'package:compare_prices/ui/commodity/create/create_commodity_dialog.dart';
import 'package:compare_prices/ui/commodity/select/commodity_popup_action.dart';
import 'package:compare_prices/ui/commodity/select/select_commodity_page_view_model.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../update/update_commodity_dialog.dart';

class SelectCommodityPage extends HookWidget {
  @override
  Widget build(context) {
    final commodities = useProvider(selectCommodityPageViewModelProvider
        .select((value) => value.commodities));
    final showingCommodities = useProvider(selectCommodityPageViewModelProvider
        .select((value) => value.showingCommodities));
    final sortType = useProvider(
        selectCommodityPageViewModelProvider.select((value) => value.sortType));
    final searchWord = useProvider(selectCommodityPageViewModelProvider
        .select((value) => value.searchWord));

    final viewModel =
        useProvider(selectCommodityPageViewModelProvider.notifier);

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

        viewModel.onRequestedToEditCommodity.stream.listen((commodity) async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return UpdateCommodityDialog(commodity: commodity);
              });

          viewModel.getList();
        });

        viewModel.onRequestedToDeleteCommodity.stream.listen((commodity) async {
          showConfirmDialog(
              context: context,
              message: "${commodity.name} を削除しますか？",
              onOk: () => viewModel.disableCommodity(commodity));
        });
      });

      return () {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.filterAndSort();
      });
      return () => {};
    }, [searchWord, commodities, sortType]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商品選択'),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return CreateCommodityDialog();
                    });

                viewModel.getList();
              },
              icon: Icon(Icons.add)),
          PopupMenuButton<CommoditySortType>(
            onSelected: (sortType) {
              viewModel.updateSortType(sortType);
            },
            icon: Icon(Icons.swap_vert),
            itemBuilder: (_) => [
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: "追加日が新しい順",
                  selectedValue: sortType,
                  value: CommoditySortType.newestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: "追加日が古い順",
                  selectedValue: sortType,
                  value: CommoditySortType.oldestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: "名前順",
                  selectedValue: sortType,
                  value: CommoditySortType.name()),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchTextField(
              labelText: "商品名",
              hintText: "商品名を入力してください。",
              onChanged: (word) {
                viewModel.updateSearchWord(word);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: showingCommodities.length,
                itemBuilder: (context, index) {
                  final commodity = showingCommodities[index];
                  return ListTile(
                    title: Text(commodity.name),
                    onTap: () => viewModel.selectCommodity(commodity),
                    trailing: PopupMenuButton<CommodityPopupAction>(
                      onSelected: (action) {
                        viewModel.handleCommodityPopupAction(action);
                      },
                      itemBuilder: (context) => [
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
