import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:hive/hive.dart';

part 'hive_purchase_result.g.dart';

@HiveType(typeId: 3)
class HivePurchaseResult extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String commodityId;

  @HiveField(2)
  String shopId;

  @HiveField(3)
  int totalPrice;

  @HiveField(4)
  int unitPrice;

  @HiveField(5)
  int count;

  @HiveField(6)
  DateTime purchaseDate;

  @HiveField(7)
  bool isEnabled;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  HivePurchaseResult(
    this.id,
    this.commodityId,
    this.shopId,
    this.totalPrice,
    this.unitPrice,
    this.count,
    this.purchaseDate,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
  );

  PurchaseResult convertToPurchaseResult() {
    return PurchaseResult(
        id: id,
        commodityId: commodityId,
        shopId: shopId,
        totalPrice: totalPrice,
        unitPrice: unitPrice,
        count: count,
        isEnabled: isEnabled,
        purchaseDate: purchaseDate,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}

extension PurchaseResultExtensions on PurchaseResult {
  HivePurchaseResult convertToHivePurchaseResult() {
    return HivePurchaseResult(
      id,
      commodityId,
      shopId,
      totalPrice,
      unitPrice,
      count,
      purchaseDate,
      isEnabled,
      createdAt,
      updatedAt,
    );
  }
}
