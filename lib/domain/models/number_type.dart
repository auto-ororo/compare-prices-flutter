import 'package:freezed_annotation/freezed_annotation.dart';

part 'number_type.freezed.dart';

@freezed
class NumberType<T> with _$NumberType<T> {
  const factory NumberType.count() = _count;
  const factory NumberType.quantity() = _quantity;
  const factory NumberType.currency() = _currency;
}
