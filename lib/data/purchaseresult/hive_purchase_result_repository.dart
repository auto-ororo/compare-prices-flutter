import 'package:collection/collection.dart';
import 'package:compare_prices/data/base/hive/box_key.dart';
import 'package:compare_prices/data/base/hive/entities/hive_commodity.dart';
import 'package:compare_prices/data/base/hive/entities/hive_purchase_result.dart';
import 'package:compare_prices/data/base/hive/entities/hive_shop.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HivePurchaseResultRepository extends PurchaseResultRepository {
  Future<Box<HivePurchaseResult>> _box =
      Hive.openBox<HivePurchaseResult>(BoxKey.purchaseResult);

  Future<Box<HiveCommodity>> _commodityBox =
      Hive.openBox<HiveCommodity>(BoxKey.commodity);

  Future<Box<HiveShop>> _shopBox = Hive.openBox<HiveShop>(BoxKey.shop);

  Future<List<PurchaseResult>> _getAllPurchaseResults() async {
    final purchaseResults = (await _box).values;
    final commodities = (await _commodityBox).values;
    final shops = (await _shopBox).values;

    var list = <PurchaseResult>[];

    for (final element in purchaseResults) {
      final commodity = commodities
          .firstWhereOrNull((c) => element.commodityId == c.id)
          ?.convertToCommodity();
      if (commodity == null) continue;
      final shop = shops
          .firstWhereOrNull((s) => element.shopId == s.id)
          ?.convertToShop();
      if (shop == null) continue;
      list.add(element.convertToPurchaseResult(commodity, shop));
    }

    return list;
  }

  @override
  Future<void> createPurchaseResult(PurchaseResult purchaseResult) async {
    final box = await _box;
    await box.put(
        purchaseResult.id, purchaseResult.convertToHivePurchaseResult());
  }

  @override
  Future<PurchaseResult?> getMostInexpensivePurchaseResultPerUnitByCommodityId(
      String commodityId) async {
    final purchaseResults = (await _getAllPurchaseResults())
        .where((element) => (element.commodity.id == commodityId));

    if (purchaseResults.length == 0) return null;

    return purchaseResults.reduce((current, next) {
      if ((current.unitPrice()) >= (next.unitPrice())) {
        return next;
      } else {
        return current;
      }
    });
  }

  @override
  Future<PurchaseResult?> getNewestPurchaseResultByCommodityId(
      String commodityId) async {
    final purchaseResults = (await _getAllPurchaseResults())
        .where((element) => (element.commodity.id == commodityId));

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
  Future<PurchaseResult?> getPurchaseResultById(String id) async {
    final box = await _box;
    final hivePurchaseResult = box.get(id);

    if (hivePurchaseResult == null) return null;

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
  Future<List<PurchaseResult>> getPurchaseResultsByCommodityId(
      String commodityId) async {
    return (await _getAllPurchaseResults())
        .where((element) => (element.commodity.id == commodityId))
        .toList();
  }

  @override
  Future<void> updatePurchaseResult(PurchaseResult purchaseResult) async {
    final box = await _box;
    await box.put(
        purchaseResult.id, purchaseResult.convertToHivePurchaseResult());
  }

  @override
  Future<void> deletePurchaseResult(PurchaseResult purchaseResult) async {
    final box = await _box;
    await box.delete(purchaseResult.id);
  }

  @override
  Future<List<PurchaseResult>> getPurchaseResults() async {
    return (await _getAllPurchaseResults()).toList();
  }
}
