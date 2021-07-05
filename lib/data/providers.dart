import 'package:compare_prices/data/commodity/hive_commodity_repository.dart';
import 'package:compare_prices/data/example/first_example_repository.dart';
import 'package:compare_prices/data/infrastructure_config/hive_infrastructure_config_repository.dart';
import 'package:compare_prices/data/purchaseresult/hive_purchase_result_repository.dart';
import 'package:compare_prices/data/shop/hive_shop_repository.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';
import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final exampleRepositoryProvider =
    Provider.autoDispose<ExampleRepository>((ref) => FirstExampleRepository());

// ■■■■■Sample■■■■■
// final commodityRepositoryProvider = Provider.autoDispose<CommodityRepository>(
//     (ref) => SampleCommodityRepository());
// final shopRepositoryProvider =
//     Provider.autoDispose<ShopRepository>((ref) => SampleShopRepository());
// final purchaseResultRepositoryProvider =
//     Provider.autoDispose<PurchaseResultRepository>(
//         (ref) => SamplePurchaseResultRepository());

// ■■■■■Hive■■■■■
final commodityRepositoryProvider = Provider.autoDispose<CommodityRepository>(
    (ref) => HiveCommodityRepository());
final infrastructureConfigRepositoryProvider =
    Provider.autoDispose<InfrastructureConfigRepository>(
        (ref) => HiveInfrastructureConfigRepository());
final shopRepositoryProvider =
    Provider.autoDispose<ShopRepository>((ref) => HiveShopRepository());
final purchaseResultRepositoryProvider =
    Provider.autoDispose<PurchaseResultRepository>(
        (ref) => HivePurchaseResultRepository());
