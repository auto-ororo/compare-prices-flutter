import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'purchase_result.freezed.dart';

@freezed
class PurchaseResult with _$PurchaseResult {
  const factory PurchaseResult({
    required String id,
    required Commodity commodity,
    required Shop shop,
    required int price,
    required int quantity,
    required DateTime purchaseDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PurchaseResult;

  static PurchaseResult create(
      {required Commodity commodity,
      required Shop shop,
      required int price,
      required int quantity,
      required DateTime purchaseDate}) {
    final now = DateTime.now();
    return PurchaseResult(
        id: Uuid().v4(),
        commodity: commodity,
        shop: shop,
        price: price,
        quantity: quantity,
        purchaseDate: purchaseDate,
        createdAt: now,
        updatedAt: now);
  }
}

const _unitPriceBaseNumber = 10;

extension PurchaseResultExtensions on PurchaseResult {
  double unitPrice() {
    final unitPriceBeforeRound =
        (this.price / (this.quantity / this.commodity.quantityType.unit()));

    return ((unitPriceBeforeRound * _unitPriceBaseNumber).round() /
        _unitPriceBaseNumber);
  }
}
