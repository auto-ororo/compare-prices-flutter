import 'package:compare_prices/domain/models/commodity_sort_type.dart';
import 'package:compare_prices/ui/commodity/create/create_commodity_dialog.dart';
import 'package:compare_prices/ui/commodity/list/commodity_list_page_view_model.dart';
import 'package:compare_prices/ui/commodity/list/commodity_popup_action.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:compare_prices/ui/common/no_data_view.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../update/update_commodity_dialog.dart';

class CommodityListPage extends HookWidget {
  const CommodityListPage(
      {Key? key, required this.title, required this.isSelectable})
      : super(key: key);

  final bool isSelectable;
  final String title;

  @override
  Widget build(context) {
    final commodities = useProvider(commodityListPageViewModelProvider
        .select((value) => value.commodities));
    final showingCommodities = useProvider(commodityListPageViewModelProvider
        .select((value) => value.showingCommodities));
    final sortType = useProvider(
        commodityListPageViewModelProvider.select((value) => value.sortType));
    final searchWord = useProvider(
        commodityListPageViewModelProvider.select((value) => value.searchWord));

    final viewModel = useProvider(commodityListPageViewModelProvider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.getList();

        viewModel.onExceptionHappened.stream.listen((type) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(type.errorMessage(context))),
          );
        });

        if (isSelectable) {
          viewModel.onCommoditySelected.stream.listen((selectedCommodity) {
            Navigator.pop(context, selectedCommodity);
          });
        }

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
                  .commodityListDeleteConfirmation(commodity.name),
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
      drawer: isSelectable
          ? null
          : AppDrawer(
              currentRoute: RouteName.commodityListPage,
            ),
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              onPressed: () async {
                final commodity = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return CreateCommodityDialog();
                    });

                if (isSelectable) {
                  viewModel.selectCommodity(commodity);
                } else {
                  viewModel.getList();
                }
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
                      .commodityListSortByNewestCreatedAt,
                  selectedValue: sortType,
                  value: CommoditySortType.newestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .commodityListSortByOldestCreatedAt,
                  selectedValue: sortType,
                  value: CommoditySortType.oldestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!.commodityListSortByName,
                  selectedValue: sortType,
                  value: CommoditySortType.name()),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (commodities.isEmpty)
            NoDataView(
              message: AppLocalizations.of(context)!.commodityListNoData,
            ),
          if (commodities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: SearchTextField(
                labelText: AppLocalizations.of(context)!.commonCommodityName,
                hintText: AppLocalizations.of(context)!.commodityListSearchHint,
                onChanged: (word) {
                  viewModel.updateSearchWord(word);
                },
              ),
            ),
          if (commodities.isNotEmpty)
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
                              child: Text(
                                  AppLocalizations.of(context)!.commonEdit),
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
