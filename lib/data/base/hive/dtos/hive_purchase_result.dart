import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/entities/shop.dart';
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
  int price;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  DateTime purchaseDate;

  @HiveField(6)
  bool isEnabled;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime updatedAt;

  HivePurchaseResult(
    this.id,
    this.commodityId,
    this.shopId,
    this.price,
    this.quantity,
    this.purchaseDate,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
  );

  PurchaseResult convertToPurchaseResult(Commodity commodity, Shop shop) {
    return PurchaseResult(
        id: id,
        commodity: commodity,
        shop: shop,
        price: price,
        quantity: quantity,
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
      commodity.id,
      shop.id,
      price,
      quantity,
      purchaseDate,
      isEnabled,
      createdAt,
      updatedAt,
    );
  }
}
