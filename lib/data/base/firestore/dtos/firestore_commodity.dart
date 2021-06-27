import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../timestamp_cnverter.dart';

part 'firestore_commodity.freezed.dart';
part 'firestore_commodity.g.dart';

@freezed
class FirestoreCommodity with _$FirestoreCommodity {
  const FirestoreCommodity._();
  const factory FirestoreCommodity({
    required String id,
    required String name,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required bool isEnabled,
  }) = _FirestoreCommodity;

  factory FirestoreCommodity.fromJson(Map<String, dynamic> json) =>
      _$FirestoreCommodityFromJson(json);

  Commodity convertToCommodity() {
    return Commodity(
        id: id, name: name, createdAt: createdAt, updatedAt: updatedAt);
  }
}

extension CommodityExtensions on Commodity {
  FirestoreCommodity convertToFirestoreCommodity() {
    return FirestoreCommodity(
        id: id,
        name: name,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isEnabled: isEnabled);
  }
}
