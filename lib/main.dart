import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/bottom_price/bottom_price_list_page.dart';
import 'package:compare_prices/ui/commodity/select/select_commodity_page.dart';
import 'package:compare_prices/ui/create_purchase_result/create_purchase_result_page.dart';
import 'package:compare_prices/ui/example/example_page.dart';
import 'package:compare_prices/ui/shop/select/select_shop_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/entities/commodity.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class RouteName {
  static const examplePage = 'example';
  static const bottomPriceListPage = 'bottom-price-list';
  static const createPurchaseResultPage = 'create-purchase-result';
  static const selectCommodityPage = 'select-bottom_price';
  static const selectShopPage = 'select-shop';
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      initialRoute: RouteName.bottomPriceListPage,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case RouteName.bottomPriceListPage:
            return MaterialPageRoute(
                builder: (context) => BottomPriceListPage());
          case RouteName.createPurchaseResultPage:
            return MaterialPageRoute(
                builder: (context) => CreatePurchaseResultPage());
          case RouteName.examplePage:
            return MaterialPageRoute(builder: (context) => ExamplePage());
          case RouteName.selectCommodityPage:
            return MaterialPageRoute<Commodity>(
                builder: (context) => SelectCommodityPage(),
                fullscreenDialog: true);
          case RouteName.selectShopPage:
            return MaterialPageRoute<Shop>(
                builder: (context) => SelectShopPage(), fullscreenDialog: true);
          default:
            return MaterialPageRoute(
                builder: (context) => BottomPriceListPage());
        }
      },
    );
  }
}
