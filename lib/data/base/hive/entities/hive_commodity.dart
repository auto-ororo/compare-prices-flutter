import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:hive/hive.dart';

part 'hive_commodity.g.dart';

@HiveType(typeId: 1)
class HiveCommodity extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String quantityTypeId;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  HiveCommodity(
    this.id,
    this.name,
    this.quantityTypeId,
    this.createdAt,
    this.updatedAt,
  );

  Commodity convertToCommodity() {
    return Commodity(
      id: id,
      name: name,
      quantityType: QuantityType.getTypeById(quantityTypeId),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension CommodityExtensions on Commodity {
  HiveCommodity convertToHiveCommodity() {
    return HiveCommodity(
      id,
      name,
      quantityType.id(),
      createdAt,
      updatedAt,
    );
  }
}
