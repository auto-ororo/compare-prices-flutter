import 'package:compare_prices/domain/entities/quantity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'commodity.freezed.dart';

@freezed
class Commodity with _$Commodity {
  const factory Commodity({
    required String id,
    required String name,
    required Quantity quantity,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
  }) = _Commodity;

  static Commodity create(String name, Quantity quantity) {
    final now = DateTime.now();
    return Commodity(
        id: Uuid().v4(),
        name: name,
        quantity: quantity,
        createdAt: now,
        updatedAt: now);
  }
}
