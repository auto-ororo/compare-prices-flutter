import 'package:compare_prices/app.dart';
import 'package:compare_prices/domain/entities/bottom_price_sort_type.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/no_data_view.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/common/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bottom_price_list_page_view_model.dart';
import 'bottom_price_row.dart';

class BottomPriceListPage extends HookWidget {
  @override
  Widget build(context) {
    final searchWord = useProvider(bottomPriceListPageViewModelProvider
        .select((value) => value.searchWord));

    final bottomPrices = useProvider(bottomPriceListPageViewModelProvider
        .select((value) => value.bottomPrices));
    final showingBottomPrices = useProvider(bottomPriceListPageViewModelProvider
        .select((value) => value.showingBottomPrices));
    final sortType = useProvider(
        bottomPriceListPageViewModelProvider.select((value) => value.sortType));
    final viewModel =
        useProvider(bottomPriceListPageViewModelProvider.notifier);

    final textEditingController = useTextEditingController();
    final debouncer = Debouncer(milliseconds: 250);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.getList();

        viewModel.onExceptionHappened.stream.listen((type) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(type.errorMessage(context))),
          );
        });
      });

      return () {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.filterAndSort();
      });
      return () => {};
    }, [searchWord, bottomPrices, sortType]);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.bottomPriceListTitle),
        actions: [
          PopupMenuButton<BottomPriceSortType>(
            onSelected: (sortType) {
              viewModel.updateSortType(sortType);
            },
            icon: Icon(Icons.swap_vert),
            itemBuilder: (_) => [
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .bottomPriceListSortByNewestPurchaseDate,
                  selectedValue: sortType,
                  value: BottomPriceSortType.newestPurchaseDate()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .bottomPriceListSortByOldestPurchaseDate,
                  selectedValue: sortType,
                  value: BottomPriceSortType.oldestPurchaseDate()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .bottomPriceListSortByCommodityName,
                  selectedValue: sortType,
                  value: BottomPriceSortType.commodity()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .bottomPriceListSortByShopName,
                  selectedValue: sortType,
                  value: BottomPriceSortType.shop()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text:
                      AppLocalizations.of(context)!.bottomPriceListSortByPrice,
                  selectedValue: sortType,
                  value: BottomPriceSortType.price()),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (bottomPrices.isEmpty)
            NoDataView(
              message: AppLocalizations.of(context)!.bottomPriceListNoData,
            ),
          if (bottomPrices.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: SearchTextField(
                controller: textEditingController,
                labelText: AppLocalizations.of(context)!.commonSearch,
                hintText:
                    AppLocalizations.of(context)!.bottomPriceListSearchHint,
                onChanged: (word) {
                  debouncer.run(() => viewModel.updateSearchWord(word));
                },
              ),
            ),
          if (bottomPrices.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: showingBottomPrices.length,
                  itemBuilder: (context, index) {
                    final row = showingBottomPrices[index];
                    return BottomPriceRow(row, () async {
                      await Navigator.pushNamed(
                          context, RouteName.commodityPriceListPage,
                          arguments: {ArgumentName.commodity: row.commodity});
                      viewModel.getList();
                    });
                  }),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context)
                .pushNamed(RouteName.createPurchaseResultPage);
            viewModel.getList();
          }),
    );
  }
}
