import 'package:compare_prices/data/base/hive/box_key.dart';
import 'package:compare_prices/data/base/hive/dtos/hive_commodity.dart';
import 'package:compare_prices/data/base/hive/dtos/hive_purchase_result.dart';
import 'package:compare_prices/data/base/hive/dtos/hive_shop.dart';
import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HivePurchaseResultRepository extends PurchaseResultRepository {
  Future<Box<HivePurchaseResult>> _box =
      Hive.openBox<HivePurchaseResult>(BoxKey.purchaseResult);

  Future<Box<HiveCommodity>> _commodityBox =
      Hive.openBox<HiveCommodity>(BoxKey.commodity);

  Future<Box<HiveShop>> _shopBox = Hive.openBox<HiveShop>(BoxKey.shop);

  Future<List<PurchaseResult>> _getAllPurchaseResults() async {
    final box = await _box;
    final commodities = (await _commodityBox).values;
    final shops = (await _shopBox).values;

    return box.values.toList().map((e) {
      final commodity = commodities
          .firstWhere((c) => e.commodityId == c.id)
          .convertToCommodity();
      final shop = shops.firstWhere((s) => e.shopId == s.id).convertToShop();
      return e.convertToPurchaseResult(commodity, shop);
    }).toList();
  }

  @override
  Future<void> createPurchaseResult(PurchaseResult purchaseResult) async {
    final box = await _box;
    await box.put(
        purchaseResult.id, purchaseResult.convertToHivePurchaseResult());
  }

  @override
  Future<PurchaseResult?>
      getEnabledMostInexpensivePurchaseResultPerUnitByCommodityId(
          String commodityId) async {
    final purchaseResults = (await _getAllPurchaseResults()).where((element) =>
        (element.commodity.id == commodityId) && (element.isEnabled));

    if (purchaseResults.length == 0) return null;

    return purchaseResults.reduce((current, next) {
      if (current.unitPrice >= next.unitPrice) {
        return next;
      } else {
        return current;
      }
    });
  }

  @override
  Future<PurchaseResult?> getEnabledNewestPurchaseResultByCommodityId(
      String commodityId) async {
    final purchaseResults = (await _getAllPurchaseResults()).where((element) =>
        (element.commodity.id == commodityId) && (element.isEnabled));

    if (purchaseResults.length == 0) return null;

    return purchaseResults.reduce((current, next) {
      if (current.purchaseDate.compareTo(next.purchaseDate) == -1) {
        return next;
      } else {
        return current;
      }
    });
  }

  @override
  Future<PurchaseResult?> getEnabledPurchaseResultById(String id) async {
    final box = await _box;
    final hivePurchaseResult = box.get(id);

    if (hivePurchaseResult == null || !hivePurchaseResult.isEnabled)
      return null;

    final commodities = (await _commodityBox).values;
    final shops = (await _shopBox).values;

    final commodity = commodities
        .firstWhere((c) => hivePurchaseResult.commodityId == c.id)
        .convertToCommodity();

    final shop = shops
        .firstWhere((s) => hivePurchaseResult.shopId == s.id)
        .convertToShop();

    return hivePurchaseResult.convertToPurchaseResult(commodity, shop);
  }

  @override
  Future<List<PurchaseResult>> getEnabledPurchaseResultsByCommodityId(
      String commodityId) async {
    return (await _getAllPurchaseResults())
        .where((element) =>
            (element.commodity.id == commodityId) && element.isEnabled)
        .toList();
  }

  @override
  Future<void> updatePurchaseResult(PurchaseResult purchaseResult) async {
    final box = await _box;
    await box.put(
        purchaseResult.id, purchaseResult.convertToHivePurchaseResult());
  }

  @override
  Future<List<PurchaseResult>> getEnabledPurchaseResults() async {
    return (await _getAllPurchaseResults())
        .where((element) => element.isEnabled)
        .toList();
  }
}
