import 'package:compare_prices/domain/entities/purchase_result.dart';

abstract class PurchaseResultRepository {
  Future<void> createPurchaseResult(PurchaseResult purchaseResult);

  Future<void> updatePurchaseResult(PurchaseResult purchaseResult);

  Future<void> deletePurchaseResult(PurchaseResult purchaseResult);

  Future<PurchaseResult?> getEnabledNewestPurchaseResultByCommodityId(
      String commodityId);

  Future<PurchaseResult?> getEnabledMostInexpensivePurchaseResultByCommodityId(
      String commodityId);

  Future<PurchaseResult?> getEnabledPurchaseResultById(String id);

  Future<List<PurchaseResult>> getEnabledPurchaseResultsByCommodityId(
      String commodityId);
}
