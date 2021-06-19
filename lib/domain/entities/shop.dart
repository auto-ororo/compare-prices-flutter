import 'package:freezed_annotation/freezed_annotation.dart';

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
}
