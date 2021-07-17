import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'commodity/select/select_commodity_page.dart';
import 'price/bottom/bottom_price_list_page.dart';
import 'price/commodity/commodity_price_list_page.dart';
import 'purchase_result/create/create_purchase_result_page.dart';
import 'shop/select/select_shop_page.dart';

class RouteName {
  static const homePage = 'home-page';
  static const bottomPriceListPage = 'bottom-price-list';
  static const createPurchaseResultPage = 'create-purchase-result';
  static const selectCommodityPage = 'select-bottom-price';
  static const selectShopPage = 'select-shop';
  static const commodityPriceListPage = 'commodity-price-list';
}

class ArgumentName {
  static const commodity = 'commodity';
}

RouteFactory route = (RouteSettings settings) {
  switch (settings.name) {
    case RouteName.homePage:
      return MaterialPageRoute(builder: (context) => HomePage());
    case RouteName.bottomPriceListPage:
      return MaterialPageRoute(builder: (context) => BottomPriceListPage());
    case RouteName.commodityPriceListPage:
      final Map args = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) =>
              CommodityPriceListPage(commodity: args[ArgumentName.commodity]));
    case RouteName.createPurchaseResultPage:
      final Map? args;
      if (settings.arguments != null) {
        args = settings.arguments as Map;
      } else {
        args = null;
      }
      return MaterialPageRoute(
          builder: (context) => CreatePurchaseResultPage(
              initialCommodity: args?[ArgumentName.commodity]),
          fullscreenDialog: true);
    case RouteName.selectCommodityPage:
      return MaterialPageRoute<Commodity>(
          builder: (context) => SelectCommodityPage(), fullscreenDialog: true);
    case RouteName.selectShopPage:
      return MaterialPageRoute<Shop>(
          builder: (context) => SelectShopPage(), fullscreenDialog: true);
    default:
      return MaterialPageRoute(builder: (context) => BottomPriceListPage());
  }
};
