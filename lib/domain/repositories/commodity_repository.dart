import 'package:compare_prices/domain/entities/commodity.dart';

abstract class CommodityRepository {
  Future<void> createCommodity(Commodity commodity);

  Future<void> updateCommodity(Commodity commodity);

  Future<List<Commodity>> getEnabledCommodities();

  Future<List<Commodity>> getAllCommodities();

  Future<Commodity?> getEnabledCommodityById(String id);

  Future<Commodity?> getEnabledCommodityByName(String name);
}
