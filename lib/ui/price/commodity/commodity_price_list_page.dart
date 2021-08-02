import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/ui/common/extensions/exception_type_extensions.dart';
import 'package:compare_prices/ui/price/commodity/commodity_price_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import 'commodity_price_list_page_view_model.dart';

class CommodityPriceListPage extends HookWidget {
  final Commodity commodity;

  const CommodityPriceListPage({Key? key, required this.commodity})
      : super(key: key);

  @override
  Widget build(context) {
    final provider = commodityPriceListPageViewModelProvider(commodity);
    final commodityPrices =
        useProvider(provider.select((value) => value.commodityPrices));
    final showingCommodityPrices =
        useProvider(provider.select((value) => value.showingCommodityPrices));
    final viewModel = useProvider(provider.notifier);
    final shouldGroupByShop =
        useProvider(provider.select((value) => value.shouldGroupByShop));

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
        viewModel.filterCommodityPrices();
      });

      return () {};
    }, [commodityPrices, shouldGroupByShop]);

    return Scaffold(
      appBar: AppBar(
        title: Text(commodity.name),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.commodityPriceListGroupByShop,
              ),
              Switch(
                  value: shouldGroupByShop,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: viewModel.updateShouldGroupByShop)
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: showingCommodityPrices.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final row = showingCommodityPrices[index];
                  return CommodityPriceRow(row, () {
                    viewModel.disablePurchaseResult(row.purchaseResultId);
                  });
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).pushNamed(
                RouteName.createPurchaseResultPage,
                arguments: {ArgumentName.commodity: commodity});
            viewModel.getList();
          }),
    );
  }
}
