import 'package:compare_prices/domain/entities/purchase_result_sort_type.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/common/no_data_view.dart';
import 'package:compare_prices/ui/common/recognizable_selected_state_popup_menu_item.dart';
import 'package:compare_prices/ui/purchase_result/list/purchase_result_list_page_view_model.dart';
import 'package:compare_prices/ui/purchase_result/list/purchase_result_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import 'purchase_result_list_page_view_model.dart';

class PurchaseResultListPage extends HookWidget {
  const PurchaseResultListPage({Key? key}) : super(key: key);

  static const floatingActionButtonHeroTag = "purchase-result-list";

  @override
  Widget build(context) {
    final viewModel =
        useProvider(purchaseResultListPageViewModelProvider.notifier);

    final purchaseResults = useProvider(purchaseResultListPageViewModelProvider
        .select((value) => value.purchaseResults));

    final showingPurchaseResults = useProvider(
        purchaseResultListPageViewModelProvider
            .select((value) => value.showingPurchaseResults));
    final sortType = useProvider(purchaseResultListPageViewModelProvider
        .select((value) => value.sortType));

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

      return () async {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.sort();
      });
      return () => {};
    }, [purchaseResults, sortType]);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.purchaseResultListTitle),
        actions: [
          PopupMenuButton<PurchaseResultSortType>(
            onSelected: (sortType) {
              viewModel.updateSortType(sortType);
            },
            icon: Icon(Icons.swap_vert),
            itemBuilder: (_) => [
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .purchaseResultListSortByNewestPurchaseDate,
                  selectedValue: sortType,
                  value: PurchaseResultSortType.newestPurchaseDate()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .purchaseResultListSortByOldestPurchaseDate,
                  selectedValue: sortType,
                  value: PurchaseResultSortType.oldestPurchaseDate()),
              RecognizableSelectedStatePopupMenuItem(
                  context: context,
                  text: AppLocalizations.of(context)!
                      .purchaseResultListSortByNewestCreatedAt,
                  selectedValue: sortType,
                  value: PurchaseResultSortType.newestCreatedAt()),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (purchaseResults.isEmpty)
            NoDataView(
              message: AppLocalizations.of(context)!.commodityPriceListNoData,
            ),
          if (purchaseResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: showingPurchaseResults.length,
                  itemBuilder: (context, index) {
                    final row = showingPurchaseResults[index];
                    return PurchaseResultRow(
                        row, () => viewModel.disablePurchaseResult(row.id));
                  }),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: floatingActionButtonHeroTag,
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context)
                .pushNamed(RouteName.createPurchaseResultPage);
            viewModel.getList();
          }),
    );
  }
}
