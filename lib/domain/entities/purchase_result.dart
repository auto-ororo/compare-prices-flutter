import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'purchase_result.freezed.dart';

@freezed
class PurchaseResult with _$PurchaseResult {
  const factory PurchaseResult({
    required String id,
    required Commodity commodity,
    required Shop shop,
    required int totalPrice,
    required int unitPrice,
    required int count,
    required DateTime purchaseDate,
    @Default(true) bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PurchaseResult;

  static PurchaseResult create(
      {required Commodity commodity,
      required Shop shop,
      required int totalPrice,
      required int unitPrice,
      required int count,
      required DateTime purchaseDate}) {
    final now = DateTime.now();
    return PurchaseResult(
        id: Uuid().v4(),
        commodity: commodity,
        shop: shop,
        totalPrice: totalPrice,
        unitPrice: unitPrice,
        count: count,
        purchaseDate: purchaseDate,
        createdAt: now,
        updatedAt: now);
  }
}
