import 'package:compare_prices/domain/models/shop.dart';

abstract class ShopRepository {
  Future<void> createShop(Shop shop);

  Future<void> updateShop(Shop shop);

  Future<void> deleteShop(Shop shop);

  Future<List<Shop>> getShops();

  Future<Shop?> getShopById(String id);

  Future<Shop?> getShopByName(String name);
}
