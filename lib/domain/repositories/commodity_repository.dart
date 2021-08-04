import 'package:compare_prices/domain/models/commodity.dart';

abstract class CommodityRepository {
  Future<void> createCommodity(Commodity commodity);

  Future<void> updateCommodity(Commodity commodity);

  Future<void> deleteCommodity(Commodity commodity);

  Future<List<Commodity>> getCommodities();

  Future<Commodity?> getCommodityById(String id);

  Future<Commodity?> getCommodityByName(String name);
}
