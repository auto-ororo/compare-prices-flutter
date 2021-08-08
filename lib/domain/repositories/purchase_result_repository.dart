import 'package:compare_prices/domain/models/purchase_result.dart';

abstract class PurchaseResultRepository {
  Future<void> createPurchaseResult(PurchaseResult purchaseResult);

  Future<void> deletePurchaseResult(PurchaseResult purchaseResult);

  Future<PurchaseResult?> getNewestPurchaseResultByCommodityId(
      String commodityId);

  Future<PurchaseResult?> getMostInexpensivePurchaseResultPerUnitByCommodityId(
      String commodityId);

  Future<PurchaseResult?> getPurchaseResultById(String id);

  Future<List<PurchaseResult>> getPurchaseResultsByCommodityId(
      String commodityId);

  Future<List<PurchaseResult>> getPurchaseResults();
}
