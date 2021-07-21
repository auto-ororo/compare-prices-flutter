import 'package:compare_prices/domain/entities/purchase_result.dart';

abstract class PurchaseResultRepository {
  Future<void> createPurchaseResult(PurchaseResult purchaseResult);

  Future<void> updatePurchaseResult(PurchaseResult purchaseResult);

  Future<PurchaseResult?> getEnabledNewestPurchaseResultByCommodityId(
      String commodityId);

  Future<PurchaseResult?>
      getEnabledMostInexpensivePurchaseResultPerUnitByCommodityId(
          String commodityId);

  Future<PurchaseResult?> getEnabledPurchaseResultById(String id);

  Future<List<PurchaseResult>> getEnabledPurchaseResultsByCommodityId(
      String commodityId);

  Future<List<PurchaseResult>> getEnabledPurchaseResults();
}
