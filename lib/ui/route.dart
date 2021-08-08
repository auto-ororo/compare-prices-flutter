import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/ui/commodity/list/commodity_list_page.dart';
import 'package:compare_prices/ui/purchase_result/list/purchase_result_list_page.dart';
import 'package:compare_prices/ui/shop/list/shop_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'price/bottom/bottom_price_list_page.dart';
import 'price/commodity/commodity_price_list_page.dart';
import 'purchase_result/create/create_purchase_result_page.dart';

class RouteName {
  static const bottomPriceListPage = 'bottom-price-list';
  static const createPurchaseResultPage = 'create-purchase-result';
  static const purchaseResultListPage = 'purchase-result-list';
  static const commodityListPage = 'commodity-list';
  static const shopListPage = 'shop-list';
  static const commodityPriceListPage = 'commodity-price-list';
  static const licensePage = 'license';
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
    case RouteName.commodityListPage:
      return MaterialPageRoute<Commodity>(
          builder: (context) => CommodityListPage(
              title: args![ArgumentName.title],
              isSelectable: args[ArgumentName.isSelectable]),
          fullscreenDialog: args![ArgumentName.isFullscreenDialog] ?? false);
    case RouteName.shopListPage:
      return MaterialPageRoute<Shop>(
          builder: (context) => ShopListPage(
              title: args![ArgumentName.title],
              isSelectable: args[ArgumentName.isSelectable]),
          fullscreenDialog: args![ArgumentName.isFullscreenDialog] ?? false);
    default: // RouteName.commodityListPage
      return MaterialPageRoute(builder: (context) => BottomPriceListPage());
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
