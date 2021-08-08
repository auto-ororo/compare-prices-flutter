import 'package:compare_prices/data/base/hive/box_key.dart';
import 'package:compare_prices/data/base/hive/entities/hive_commodity.dart';
import 'package:compare_prices/data/base/hive/entities/hive_purchase_result.dart';
import 'package:compare_prices/data/base/hive/entities/hive_shop.dart';
import 'package:compare_prices/data/infrastructure_config/hive_infrastructure_config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../../helper.dart';

void main() async {
  group('HiveInfrastructureConfigRepository', () {
    late HiveInfrastructureConfigRepository repository;

    setUp(() {
      repository = HiveInfrastructureConfigRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
    });

    testWithBuildContext('初期化できること', (context) async {
      await repository.initialize();

      // 初期化後、Adapterを使ってデータ登録できることを確認
      // 例外が発生しなければ登録できているとみなす
      final commodityBox = await Hive.openBox(BoxKey.commodity);
      await commodityBox.put(
        "1",
        HiveCommodity(
            "1", "commodityName", "1", DateTime.now(), DateTime.now()),
      );
      final shopBox = await Hive.openBox(BoxKey.shop);
      await shopBox.put(
        "2",
        HiveShop("2", "shopName", DateTime.now(), DateTime.now()),
      );
      final purchaseResultBox = await Hive.openBox(BoxKey.purchaseResult);
      await purchaseResultBox.put(
        "3",
        HivePurchaseResult("3", "1", "2", 100, 1, DateTime.now(),
            DateTime.now(), DateTime.now()),
      );
    });
  });
}
