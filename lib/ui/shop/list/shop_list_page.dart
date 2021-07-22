import 'package:compare_prices/domain/entities/shop_sort_type.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:compare_prices/ui/common/no_data_view.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/drawer/app_drawer.dart';
import 'package:compare_prices/ui/route.dart';
import 'package:compare_prices/ui/shop/create/create_shop_dialog.dart';
import 'package:compare_prices/ui/shop/list/shop_list_page_view_model.dart';
import 'package:compare_prices/ui/shop/list/shop_popup_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../update/update_shop_dialog.dart';

class ShopListPage extends HookWidget {
  const ShopListPage(
      {Key? key, required this.title, required this.isSelectable})
      : super(key: key);

  final bool isSelectable;
  final String title;

  @override
  Widget build(context) {
    final shops = useProvider(
        shopListPageViewModelProvider.select((value) => value.shops));
    final showingShops = useProvider(
        shopListPageViewModelProvider.select((value) => value.showingShops));
    final sortType = useProvider(
        shopListPageViewModelProvider.select((value) => value.sortType));
    final searchWord = useProvider(
        shopListPageViewModelProvider.select((value) => value.searchWord));
    final viewModel = useProvider(shopListPageViewModelProvider.notifier);

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
          viewModel.onShopSelected.stream.listen((selectedShop) {
            Navigator.pop(context, selectedShop);
          });
        }

        viewModel.onRequestedToEditShop.stream.listen((shop) async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return UpdateShopDialog(shop: shop);
              });

          viewModel.getList();
        });

        viewModel.onRequestedToDeleteShop.stream.listen((shop) async {
          showConfirmDialog(
              context: context,
              message: AppLocalizations.of(context)!
                  .selectShopDeleteConfirmation(shop.name),
              onOk: () => viewModel.disableShop(shop));
        });
      });

      return () {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.filterAndSort();
      });
      return () => {};
    }, [searchWord, shops, sortType]);

    return Scaffold(
      drawer: AppDrawer(
        currentRoute: RouteName.shopListPage,
      ),
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return CreateShopDialog();
                  });

              viewModel.getList();
            },
            icon: Icon(Icons.add),
          ),
          PopupMenuButton<ShopSortType>(
            onSelected: (sortType) {
              viewModel.updateSortType(sortType);
            },
            icon: Icon(Icons.swap_vert),
            itemBuilder: (_) => [
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .selectShopSortByNewestCreatedAt,
                  selectedValue: sortType,
                  value: ShopSortType.newestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .selectShopSortByOldestCreatedAt,
                  selectedValue: sortType,
                  value: ShopSortType.oldestCreatedAt()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!.selectShopSortByName,
                  selectedValue: sortType,
                  value: ShopSortType.name()),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (shops.isEmpty)
            NoDataView(
              message: AppLocalizations.of(context)!.selectShopNoData,
            ),
          if (shops.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: SearchTextField(
                labelText: AppLocalizations.of(context)!.commonShopName,
                hintText: AppLocalizations.of(context)!.selectShopSearchHint,
                onChanged: (word) {
                  viewModel.updateSearchWord(word);
                },
              ),
            ),
          if (shops.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: showingShops.length,
                  itemBuilder: (context, index) {
                    final shop = showingShops[index];
                    return ListTile(
                      title: Text(shop.name),
                      onTap: () => viewModel.selectShop(shop),
                      trailing: PopupMenuButton<ShopPopupAction>(
                        onSelected: (action) {
                          viewModel.handleShopPopupAction(action);
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child: Text(
                                  AppLocalizations.of(context)!.commonEdit),
                              value: ShopPopupAction.edit(shop)),
                          PopupMenuItem(
                            child: Text(
                              AppLocalizations.of(context)!.commonDelete,
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            value: ShopPopupAction.delete(shop),
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
