import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/add_purchase_result/add_purchase_result_page.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page.dart';
import 'package:compare_prices/ui/example/example_page.dart';
import 'package:compare_prices/ui/select_commodity/select_commodity_dialog.dart';
import 'package:compare_prices/ui/select_shop/select_shop_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/entities/commodity.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class RouteName {
  static const examplePage = 'example';
  static const commodityListPage = 'commodity-list';
  static const addPurchaseResultPage = 'add-purchase-result';
  static const selectCommodityDialog = 'select-commodity';
  static const selectShopDialog = 'select-shop';
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      initialRoute: RouteName.commodityListPage,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case RouteName.commodityListPage:
            return MaterialPageRoute(builder: (context) => CommodityListPage());
          case RouteName.addPurchaseResultPage:
            return MaterialPageRoute(
                builder: (context) => AddPurchaseResultPage());
          case RouteName.examplePage:
            return MaterialPageRoute(builder: (context) => ExamplePage());
          case RouteName.selectCommodityDialog:
            return MaterialPageRoute<Commodity>(
                builder: (context) => SelectCommodityDialog(),
                fullscreenDialog: true);
          case RouteName.selectShopDialog:
            return MaterialPageRoute<Shop>(
                builder: (context) => SelectShopDialog(),
                fullscreenDialog: true);
          default:
            return MaterialPageRoute(builder: (context) => CommodityListPage());
        }
      },
    );
  }
}
