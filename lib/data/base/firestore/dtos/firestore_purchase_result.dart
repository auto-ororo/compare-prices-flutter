import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../timestamp_cnverter.dart';

part 'firestore_purchase_result.freezed.dart';
part 'firestore_purchase_result.g.dart';

@freezed
class FirestorePurchaseResult with _$FirestorePurchaseResult {
  const FirestorePurchaseResult._();
  const factory FirestorePurchaseResult({
    required String id,
    required String commodityId,
    required String shopId,
    required int totalPrice,
    required int unitPrice,
    required int count,
    @TimestampConverter() required DateTime purchaseDate,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required bool isEnabled,
  }) = _FirestorePurchaseResult;

  factory FirestorePurchaseResult.fromJson(Map<String, dynamic> json) =>
      _$FirestorePurchaseResultFromJson(json);

  PurchaseResult convertToPurchaseResult() {
    return PurchaseResult(
        id: id,
        commodityId: commodityId,
        shopId: shopId,
        totalPrice: totalPrice,
        unitPrice: unitPrice,
        count: count,
        purchaseDate: purchaseDate,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }
}

extension PurchaseResultExtensions on PurchaseResult {
  FirestorePurchaseResult convertToFirestorePurchaseResult() {
    return FirestorePurchaseResult(
        id: id,
        commodityId: commodityId,
        shopId: shopId,
        totalPrice: totalPrice,
        unitPrice: unitPrice,
        count: count,
        purchaseDate: purchaseDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isEnabled: isEnabled);
  }
}
