import 'package:collection/collection.dart';
import 'package:compare_prices/data/base/hive/box_key.dart';
import 'package:compare_prices/data/base/hive/entities/hive_commodity.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCommodityRepository extends CommodityRepository {
  Future<Box<HiveCommodity>> _box =
      Hive.openBox<HiveCommodity>(BoxKey.commodity);

  @override
  Future<void> createCommodity(Commodity commodity) async {
    final box = await _box;
    await box.put(commodity.id, commodity.convertToHiveCommodity());
  }

  @override
  Future<List<Commodity>> getCommodities() async {
    final box = await _box;

    return box.values.toList().map((e) => e.convertToCommodity()).toList();
  }

  @override
  Future<Commodity?> getCommodityById(String id) async {
    final box = await _box;

    return box.get(id)?.convertToCommodity();
  }

  @override
  Future<Commodity?> getCommodityByName(String name) async {
    final list = await getCommodities();
    return list.firstWhereOrNull((element) => (element.name == name));
  }

  @override
  Future<void> updateCommodity(Commodity commodity) async {
    final box = await _box;
    await box.put(commodity.id, commodity.convertToHiveCommodity());
  }

  @override
  Future<void> deleteCommodity(Commodity commodity) async {
    final box = await _box;
    await box.delete(commodity.id);
  }
}
