import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/home/home_page.dart';
import 'package:compare_prices/ui/other/other_page.dart';
import 'package:compare_prices/ui/purchase_result/list/purchase_result_list_page.dart';
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
  static const purchaseResultListPage = 'purchase-result-list';
  static const selectCommodityPage = 'select-bottom-price';
  static const selectShopPage = 'select-shop';
  static const commodityPriceListPage = 'commodity-price-list';
  static const otherPage = 'other';
}

class ArgumentName {
  static const commodity = 'commodity';
  static const isSelectable = 'isSelectable';
  static const isFullscreenDialog = 'isFullscreenDialog';
  static const title = 'title';
}

RouteFactory route = (RouteSettings settings) {
  final args = _getArguments(settings.arguments);
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
      return MaterialPageRoute(
          builder: (context) => CreatePurchaseResultPage(
              initialCommodity: args?[ArgumentName.commodity]),
          fullscreenDialog: true);
    case RouteName.purchaseResultListPage:
      return MaterialPageRoute(builder: (context) => PurchaseResultListPage());
    case RouteName.selectCommodityPage:
      return MaterialPageRoute<Commodity>(
          builder: (context) => SelectCommodityPage(
              title: args![ArgumentName.title],
              isSelectable: args[ArgumentName.isSelectable]),
          fullscreenDialog: args![ArgumentName.isFullscreenDialog] ?? false);
    case RouteName.selectShopPage:
      return MaterialPageRoute<Shop>(
          builder: (context) => SelectShopPage(
              title: args![ArgumentName.title],
              isSelectable: args[ArgumentName.isSelectable]),
          fullscreenDialog: args![ArgumentName.isFullscreenDialog] ?? false);
    case RouteName.otherPage:
      return MaterialPageRoute(builder: (context) => OtherPage());
    default:
      return MaterialPageRoute(builder: (context) => HomePage());
  }
};

Map? _getArguments(Object? arguments) {
  final Map? args;
  if (arguments != null) {
    args = arguments as Map;
  } else {
    args = null;
  }
  return args;
}
