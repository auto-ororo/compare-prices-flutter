import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../timestamp_cnverter.dart';

part 'firestore_shop.freezed.dart';
part 'firestore_shop.g.dart';

@freezed
class FirestoreShop with _$FirestoreShop {
  const FirestoreShop._();
  const factory FirestoreShop({
    required String id,
    required String name,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required bool isEnabled,
  }) = _FirestoreShop;

  factory FirestoreShop.fromJson(Map<String, dynamic> json) =>
      _$FirestoreShopFromJson(json);

  Shop convertToShop() {
    return Shop(id: id, name: name, createdAt: createdAt, updatedAt: updatedAt);
  }
}

extension ShopExtensions on Shop {
  FirestoreShop convertToFirestoreShop() {
    return FirestoreShop(
        id: id,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isEnabled: isEnabled);
  }
}
