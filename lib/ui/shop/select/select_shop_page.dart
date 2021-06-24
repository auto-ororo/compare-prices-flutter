import 'package:compare_prices/ui/common/extensions/show_dialog_extensions.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/shop/create/create_shop_dialog.dart';
import 'package:compare_prices/ui/shop/select/select_shop_page_view_model.dart';
import 'package:compare_prices/ui/shop/select/shop_popup_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../update/update_shop_dialog.dart';

class SelectShopPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final shops = useProvider(
        selectShopPageViewModelProvider.select((value) => value.shops));
    final filteredShops = useProvider(
        selectShopPageViewModelProvider.select((value) => value.filteredShops));
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
              message: "${shop.name} を削除しますか？",
              onOk: () => viewModel.deleteShop(shop));
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
    }, [searchWord, shops]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('店舗選択'),
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
              icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchTextField(
              labelText: "店舗名",
              hintText: "店舗名を入力してください。",
              onChanged: (word) {
                viewModel.updateSearchWord(word);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredShops.length,
                itemBuilder: (context, index) {
                  final shop = filteredShops[index];
                  return ListTile(
                    title: Text(shop.name),
                    onTap: () => viewModel.selectShop(shop),
                    trailing: PopupMenuButton<ShopPopupAction>(
                      onSelected: (ShopPopupAction action) {
                        viewModel.handleShopPopupAction(action);
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            child: Text("編集"),
                            value: ShopPopupAction.edit(shop)),
                        PopupMenuItem(
                          child: Text(
                            "削除",
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
