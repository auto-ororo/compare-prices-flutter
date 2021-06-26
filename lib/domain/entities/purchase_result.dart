import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'purchase_result.freezed.dart';

@freezed
class PurchaseResult with _$PurchaseResult {
  const factory PurchaseResult({
    required String id,
    required String commodityId,
    required String shopId,
    required int price,
    required int count,
    required DateTime purchaseDate,
    @Default(true) bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PurchaseResult;

  static PurchaseResult create(
      {required String commodityId,
      required String shopId,
      required int price,
      required int count,
      required DateTime purchaseDate}) {
    return PurchaseResult(
        id: Uuid().v4(),
        commodityId: commodityId,
        shopId: shopId,
        price: price,
        count: count,
        purchaseDate: purchaseDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
  }
}
