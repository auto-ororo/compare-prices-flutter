import 'package:compare_prices/domain/entities/shop_sort_type.dart';
import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/shop/create/create_shop_dialog.dart';
import 'package:compare_prices/ui/shop/select/select_shop_page_view_model.dart';
import 'package:compare_prices/ui/shop/select/shop_popup_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../update/update_shop_dialog.dart';

class SelectShopPage extends HookWidget {
  @override
  Widget build(context) {
    final shops = useProvider(
        selectShopPageViewModelProvider.select((value) => value.shops));
    final showingShops = useProvider(
        selectShopPageViewModelProvider.select((value) => value.showingShops));
    final sortType = useProvider(
        selectShopPageViewModelProvider.select((value) => value.sortType));
    final searchWord = useProvider(
        selectShopPageViewModelProvider.select((value) => value.searchWord));
    final viewModel = useProvider(selectShopPageViewModelProvider.notifier);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.getList();

        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });

        viewModel.onShopSelected.stream.listen((selectedShop) {
          Navigator.pop(context, selectedShop);
        });

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectShopTitle),
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
                            child:
                                Text(AppLocalizations.of(context)!.commonEdit),
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
