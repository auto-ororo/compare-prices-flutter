import 'package:compare_prices/data/commodity/firestore_commodity_repository.dart';
import 'package:compare_prices/data/example/first_example_repository.dart';
import 'package:compare_prices/data/purchaseresult/firestore_purchase_result_repository.dart';
import 'package:compare_prices/data/shop/firestore_shop_repository.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';
import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'infrastructure_config/firebase_infrastructure_config_repository.dart';

// Repository
final exampleRepositoryProvider =
    Provider.autoDispose<ExampleRepository>((ref) => FirstExampleRepository());

// final commodityRepositoryProvider = Provider.autoDispose<CommodityRepository>(
//     (ref) => SampleCommodityRepository());

final commodityRepositoryProvider = Provider.autoDispose<CommodityRepository>(
    (ref) => FirestoreCommodityRepository());

// final shopRepositoryProvider =
//     Provider.autoDispose<ShopRepository>((ref) => SampleShopRepository());

final shopRepositoryProvider =
    Provider.autoDispose<ShopRepository>((ref) => FirestoreShopRepository());

// final purchaseResultRepositoryProvider =
//     Provider.autoDispose<PurchaseResultRepository>(
//         (ref) => SamplePurchaseResultRepository());

final purchaseResultRepositoryProvider =
    Provider.autoDispose<PurchaseResultRepository>(
        (ref) => FirestorePurchaseResultRepository());

final infrastructureConfigRepositoryProvider =
    Provider.autoDispose<InfrastructureConfigRepository>(
        (ref) => FirebaseInfrastructureConfigRepository());
