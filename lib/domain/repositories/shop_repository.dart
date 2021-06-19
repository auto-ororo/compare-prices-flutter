import 'package:compare_prices/domain/entities/shop.dart';

abstract class ShopRepository {
  Future<void> addShop(Shop shop);

  Future<void> updateShop(Shop shop);

  Future<void> deleteShop(Shop shop);

  Future<List<Shop>> getEnabledShops();

  Future<List<Shop>> getAllShops();

  Future<Shop?> getEnabledShopById(String id);

  Future<Shop?> getEnabledShopByName(String name);
}
