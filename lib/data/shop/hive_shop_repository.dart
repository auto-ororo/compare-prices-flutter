import 'package:collection/collection.dart';
import 'package:compare_prices/data/base/hive/box_key.dart';
import 'package:compare_prices/data/base/hive/entities/hive_shop.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveShopRepository extends ShopRepository {
  Future<Box<HiveShop>> _box = Hive.openBox<HiveShop>(BoxKey.shop);

  @override
  Future<void> createShop(Shop shop) async {
    final box = await _box;
    await box.put(shop.id, shop.convertToHiveShop());
  }

  @override
  Future<List<Shop>> getShops() async {
    final box = await _box;

    return box.values.toList().map((e) => e.convertToShop()).toList();
  }

  @override
  Future<Shop?> getShopById(String id) async {
    final box = await _box;

    return box.get(id)?.convertToShop();
  }

  @override
  Future<Shop?> getShopByName(String name) async {
    final list = await getShops();
    return list.firstWhereOrNull((element) => (element.name == name));
  }

  @override
  Future<void> updateShop(Shop shop) async {
    final box = await _box;
    await box.put(shop.id, shop.convertToHiveShop());
  }

  @override
  Future<void> deleteShop(Shop shop) async {
    final box = await _box;
    await box.delete(shop.id);
  }
}
