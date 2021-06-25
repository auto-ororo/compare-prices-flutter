import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/commodity/select/select_commodity_page.dart';
import 'package:compare_prices/ui/create_purchase_result/create_purchase_result_page.dart';
import 'package:compare_prices/ui/example/example_page.dart';
import 'package:compare_prices/ui/price/bottom/bottom_price_list_page.dart';
import 'package:compare_prices/ui/price/commodity/commodity_price_list_page.dart';
import 'package:compare_prices/ui/shop/select/select_shop_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'domain/entities/commodity.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class RouteName {
  static const examplePage = 'example';
  static const bottomPriceListPage = 'bottom-price-list';
  static const createPurchaseResultPage = 'create-purchase-result';
  static const selectCommodityPage = 'select-bottom-price';
  static const selectShopPage = 'select-shop';
  static const commodityPriceListPage = 'commodity-price-list';
}

class ArgumentName {
  static const commodity = 'commodity';
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
          case RouteName.commodityPriceListPage:
            final Map args = settings.arguments as Map;
            return MaterialPageRoute(
                builder: (context) => CommodityPriceListPage(
                    commodity: args[ArgumentName.commodity]));
          case RouteName.createPurchaseResultPage:
            final Map? args;
            if (settings.arguments != null) {
              args = settings.arguments as Map;
            } else {
              args = null;
            }
            return MaterialPageRoute(
                builder: (context) => CreatePurchaseResultPage(
                    initialCommodity: args?[ArgumentName.commodity]));
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
