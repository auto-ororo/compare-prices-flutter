import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/quantity.dart';
import 'package:hive/hive.dart';

part 'hive_commodity.g.dart';

@HiveType(typeId: 1)
class HiveCommodity extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String quantityId;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  bool isEnabled;

  HiveCommodity(
    this.id,
    this.name,
    this.quantityId,
    this.createdAt,
    this.updatedAt,
    this.isEnabled,
  );

  Commodity convertToCommodity() {
    return Commodity(
      id: id,
      name: name,
      quantity: Quantity.getTypeById(quantityId),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isEnabled: isEnabled,
    );
  }
}

extension CommodityExtensions on Commodity {
  HiveCommodity convertToHiveCommodity() {
    return HiveCommodity(
        id, name, quantity.id(), createdAt, updatedAt, isEnabled);
  }
}
