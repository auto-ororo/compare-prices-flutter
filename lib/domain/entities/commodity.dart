import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'commodity.freezed.dart';

@freezed
class Commodity with _$Commodity {
  const factory Commodity({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
  }) = _Commodity;

  static Commodity createByName(String name) {
    final now = DateTime.now();
    return Commodity(
        id: Uuid().v4(), name: name, createdAt: now, updatedAt: now);
  }
}
