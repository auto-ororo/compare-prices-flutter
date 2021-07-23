import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/ui/assets/color/app_colors.dart';
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
    final viewModel = useProvider(provider.notifier);

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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.commodityPriceListTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              commodity.name,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.commodityPriceListRanking,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.primary),
          Expanded(
            child: ListView.builder(
                itemCount: commodityPrices.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final row = commodityPrices[index];
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
