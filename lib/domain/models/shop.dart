import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'shop.freezed.dart';

@freezed
class Shop with _$Shop {
  const factory Shop({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
  }) = _Shop;

  static Shop createByName(String name) {
    final now = DateTime.now();
    return Shop(id: Uuid().v4(), name: name, createdAt: now, updatedAt: now);
  }
}
