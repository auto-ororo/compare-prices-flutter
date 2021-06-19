import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_result.freezed.dart';

@freezed
class PurchaseResult with _$PurchaseResult {
  const factory PurchaseResult({
    required String id,
    required String commodityId,
    required String shopId,
    required int price,
    required DateTime purchaseDate,
    @Default(true) bool isEnabled,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PurchaseResult;
}
