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
  Future<List<Shop>> getAllShops() async {
    final box = await _box;

    return box.values.toList().map((e) => e.convertToShop()).toList();
  }

  @override
  Future<Shop?> getEnabledShopById(String id) async {
    final box = await _box;

    return box.get(id)?.convertToShop();
  }

  @override
  Future<Shop?> getEnabledShopByName(String name) async {
    final list = await getAllShops();
    return list.firstWhereOrNull(
        (element) => (element.name == name) && element.isEnabled);
  }

  @override
  Future<List<Shop>> getEnabledShops() async {
    final list = await getAllShops();

    return list.where((element) => element.isEnabled).toList();
  }

  @override
  Future<void> updateShop(Shop shop) async {
    final box = await _box;
    await box.put(shop.id, shop.convertToHiveShop());
  }
}
