import 'package:compare_prices/data/base/hive/entities/hive_commodity.dart';
import 'package:compare_prices/data/base/hive/entities/hive_purchase_result.dart';
import 'package:compare_prices/data/base/hive/entities/hive_shop.dart';
import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInfrastructureConfigRepository
    extends InfrastructureConfigRepository {
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();

    // アダプターの追加
    Hive.registerAdapter(HiveCommodityAdapter());
    Hive.registerAdapter(HiveShopAdapter());
    Hive.registerAdapter(HivePurchaseResultAdapter());
  }
}
