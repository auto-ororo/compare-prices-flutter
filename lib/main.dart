import 'package:compare_prices/ui/add_purchase_result/add_purchase_result_page.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page.dart';
import 'package:compare_prices/ui/example/example_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class Const {
  static const routeNameExamplePage = 'example-page';
  static const routeCommodityList = 'commodity-list';
  static const addPurchaseResult = 'add-purchase-result';
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.blueAccent),
      routes: {
        Const.routeNameExamplePage: (BuildContext context) => ExamplePage(),
        Const.routeCommodityList: (BuildContext context) => CommodityListPage(),
        Const.addPurchaseResult: (BuildContext context) =>
            AddPurchaseResultPage(),
      },
      home: CommodityListPage(),
    );
  }
}
