import 'package:collection/collection.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';

class SampleShopRepository extends ShopRepository {
  final _sampleData = _SampleData();

  @override
  Future<void> addShop(Shop shop) async {
    _sampleData.shops.add(shop);
  }

  @override
  Future<void> deleteShop(Shop shop) async {
    final index =
        _sampleData.shops.indexWhere((element) => element.id == shop.id);
    final target = _sampleData.shops[index];
    _sampleData.shops[index] = target.copyWith(isEnabled: false);
  }

  @override
  Future<List<Shop>> getAllShops() async {
    return _sampleData.shops;
  }

  @override
  Future<Shop?> getEnabledShopById(String id) async {
    return _sampleData.shops
        .firstWhereOrNull((element) => (element.id == id) && element.isEnabled);
  }

  @override
  Future<Shop?> getEnabledShopByName(String name) async {
    return _sampleData.shops.firstWhereOrNull(
        (element) => (element.name == name) && element.isEnabled);
  }

  @override
  Future<List<Shop>> getEnabledShops() async {
    return _sampleData.shops.where((element) => element.isEnabled).toList();
  }

  @override
  Future<void> updateShop(Shop shop) async {
    final index =
        _sampleData.shops.indexWhere((element) => element.id == shop.id);
    _sampleData.shops[index] = shop;
  }
}

class _SampleData {
  static _SampleData? _instance;

  List<Shop> shops = [
    Shop(
        id: "s1",
        name: "マルエツ",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s2",
        name: "イオン",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s3",
        name: "イトーヨーカドー",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s4",
        name: "ウエルシア",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s5",
        name: "西友",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s6",
        name: "スーパー玉出",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s7",
        name: "原信",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s8",
        name: "生協",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s9",
        name: "Amazon",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Shop(
        id: "s10",
        name: "楽天",
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
