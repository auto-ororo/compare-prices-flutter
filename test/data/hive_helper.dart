import 'dart:io';

import 'package:compare_prices/data/base/hive/entities/hive_commodity.dart';
import 'package:compare_prices/data/base/hive/entities/hive_purchase_result.dart';
import 'package:compare_prices/data/base/hive/entities/hive_shop.dart';
import 'package:hive/hive.dart';

Future<void> initialiseHive(String directoryName) async {
  Hive
    ..init(_dataDirectory(directoryName))
    ..registerAdapter(HiveCommodityAdapter())
    ..registerAdapter(HiveShopAdapter())
    ..registerAdapter(HivePurchaseResultAdapter());

  Hive.deleteFromDisk(); // 常に空の状態で開始する
}

Future<void> deleteHiveDataDirectory(String directoryName) async {
  Directory(_dataDirectory(directoryName)).deleteSync(recursive: true);
}

String _dataDirectory(String directoryName) {
  return "${Directory.current.path}/test/${directoryName}";
}
