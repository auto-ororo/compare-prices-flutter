import 'package:compare_prices/domain/entities/commodity_sort_type.dart';
import 'package:compare_prices/ui/commodity/create/create_commodity_dialog.dart';
import 'package:compare_prices/ui/commodity/select/commodity_popup_action.dart';
import 'package:compare_prices/ui/commodity/select/select_commodity_page_view_model.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

        viewModel.onExceptionHappened.stream.listen((type) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(type.errorMessage(context))),
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
              message: AppLocalizations.of(context)!
                  .selectCommodityDeleteConfirmation(commodity.name),
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
        title: Text(AppLocalizations.of(context)!.selectCommodityTitle),
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
                  text: AppLocalizations.of(context)!
                      .selectCommoditySortByNewestCreatedAt,
                  selectedValue: sortType,
                  value: CommoditySortType.newestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .selectCommoditySortByOldestCreatedAt,
                  selectedValue: sortType,
                  value: CommoditySortType.oldestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!.selectCommoditySortByName,
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
              labelText: AppLocalizations.of(context)!.commonCommodityName,
              hintText: AppLocalizations.of(context)!.selectCommoditySearchHint,
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
                            child:
                                Text(AppLocalizations.of(context)!.commonEdit),
                            value: CommodityPopupAction.edit(commodity)),
                        PopupMenuItem(
                          child: Text(
                            AppLocalizations.of(context)!.commonDelete,
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
