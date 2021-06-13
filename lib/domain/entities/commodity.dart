import 'package:freezed_annotation/freezed_annotation.dart';

part 'commodity.freezed.dart';

@freezed
class Commodity with _$Commodity {
  const factory Commodity({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isEnabled,
  }) = _Commodity;
}
