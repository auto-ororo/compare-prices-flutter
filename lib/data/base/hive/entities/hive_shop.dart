import 'package:compare_prices/domain/models/shop.dart';
import 'package:hive/hive.dart';

part 'hive_shop.g.dart';

@HiveType(typeId: 2)
class HiveShop extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;

  HiveShop(
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  );

  Shop convertToShop() {
    return Shop(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ShopExtensions on Shop {
  HiveShop convertToHiveShop() {
    return HiveShop(
      id,
      name,
      createdAt,
      updatedAt,
    );
  }
}
