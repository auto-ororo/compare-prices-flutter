import 'package:collection/collection.dart';
import 'package:compare_prices/data/base/hive/dtos/hive_commodity.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCommodityRepository extends CommodityRepository {
  Future<Box<HiveCommodity>> _box = Hive.openBox<HiveCommodity>('commodity');

  @override
  Future<void> createCommodity(Commodity commodity) async {
    final box = await _box;
    await box.put(commodity.id, commodity.convertToHiveCommodity());
  }

  @override
  Future<List<Commodity>> getAllCommodities() async {
    final box = await _box;

    return box.values.toList().map((e) => e.convertToCommodity()).toList();
  }

  @override
  Future<Commodity?> getEnabledCommodityById(String id) async {
    final box = await _box;

    return box.get(id)?.convertToCommodity();
  }

  @override
  Future<Commodity?> getEnabledCommodityByName(String name) async {
    final list = await getAllCommodities();
    return list.firstWhereOrNull(
        (element) => (element.name == name) && element.isEnabled);
  }

  @override
  Future<List<Commodity>> getEnabledCommodities() async {
    final list = await getAllCommodities();

    return list.where((element) => element.isEnabled).toList();
  }

  @override
  Future<void> updateCommodity(Commodity commodity) async {
    final box = await _box;
    await box.put(commodity.id, commodity.convertToHiveCommodity());
  }
}
