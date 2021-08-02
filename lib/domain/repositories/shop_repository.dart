import 'package:compare_prices/domain/models/shop.dart';

abstract class ShopRepository {
  Future<void> createShop(Shop shop);

  Future<void> updateShop(Shop shop);

  Future<List<Shop>> getEnabledShops();

  Future<List<Shop>> getAllShops();

  Future<Shop?> getEnabledShopById(String id);

  Future<Shop?> getEnabledShopByName(String name);
}
