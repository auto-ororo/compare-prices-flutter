import 'package:compare_prices/data/base/hive/dtos/hive_purchase_result.dart';
import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HivePurchaseResultRepository extends PurchaseResultRepository {
  Future<Box<HivePurchaseResult>> _box =
      Hive.openBox<HivePurchaseResult>('purchase_result');

  Future<List<PurchaseResult>> _getAllPurchaseResults() async {
    final box = await _box;

    return box.values.toList().map((e) => e.convertToPurchaseResult()).toList();
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
        (element.commodityId == commodityId) && (element.isEnabled));

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
        (element.commodityId == commodityId) && (element.isEnabled));

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
    return box.get(id)?.convertToPurchaseResult();
  }

  @override
  Future<List<PurchaseResult>> getEnabledPurchaseResultsByCommodityId(
      String commodityId) async {
    return (await _getAllPurchaseResults())
        .where((element) =>
            (element.commodityId == commodityId) && element.isEnabled)
        .toList();
  }

  @override
  Future<void> updatePurchaseResult(PurchaseResult purchaseResult) async {
    final box = await _box;
    await box.put(
        purchaseResult.id, purchaseResult.convertToHivePurchaseResult());
  }
}
