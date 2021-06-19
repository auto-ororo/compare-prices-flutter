import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';

class SampleCommodityRepository extends CommodityRepository {
  final _sampleData = _SampleData();

  @override
  Future<void> addCommodity(Commodity commodity) async {
    _sampleData.commodities.add(commodity);
  }

  @override
  Future<void> deleteCommodity(Commodity commodity) async {
    final index = _sampleData.commodities
        .indexWhere((element) => element.id == commodity.id);
    final target = _sampleData.commodities[index];
    _sampleData.commodities[index] = target.copyWith(isEnabled: false);
  }

  @override
  Future<List<Commodity>> getAllCommodities() async {
    return _sampleData.commodities;
  }

  @override
  Future<Commodity?> getEnabledCommodityById(String id) async {
    return _sampleData.commodities.firstWhere(
        (element) => (element.id == id) && element.isEnabled,
        orElse: null);
  }

  @override
  Future<Commodity?> getEnabledCommodityByName(String name) async {
    return _sampleData.commodities.firstWhere(
        (element) => (element.name == name) && element.isEnabled,
        orElse: null);
  }

  @override
  Future<List<Commodity>> getEnabledCommodities() async {
    return _sampleData.commodities
        .where((element) => element.isEnabled)
        .toList();
  }

  @override
  Future<void> updateCommodity(Commodity commodity) async {
    final index = _sampleData.commodities
        .indexWhere((element) => element.id == commodity.id);
    _sampleData.commodities[index] = commodity;
  }
}

class _SampleData {
  static _SampleData? _instance;

  List<Commodity> commodities = [
    Commodity(
        id: "c1",
        name: "にんじん",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c2",
        name: "じゃがいも",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c3",
        name: "玉ねぎ",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c4",
        name: "キャベツ",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c5",
        name: "カレールー",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c6",
        name: "白菜",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c7",
        name: "長ネギ",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c8",
        name: "さといも",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c9",
        name: "アスパラガス",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c10",
        name: "りんご",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Commodity(
        id: "c11",
        name: "バナナ",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
  ];

  factory _SampleData() {
    if (_instance == null) {
      _instance = new _SampleData._();
    }

    return _instance!;
  }

  _SampleData._();
}
