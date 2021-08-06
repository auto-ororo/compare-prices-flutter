import 'package:compare_prices/data/commodity/hive_commodity_repository.dart';
import 'package:compare_prices/data/purchaseresult/hive_purchase_result_repository.dart';
import 'package:compare_prices/data/shop/hive_shop_repository.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../hive_helper.dart';

void main() async {
  final dataDirectoryName = 'HivePurchaseResultRepositoryTest';
  await initialiseHive(dataDirectoryName);

  group('HivePurchaseResultRepository', () {
    late HivePurchaseResultRepository repository;
    late HiveCommodityRepository commodityRepository;
    late HiveShopRepository shopRepository;

    setUp(() {
      repository = HivePurchaseResultRepository();
      commodityRepository = HiveCommodityRepository();
      shopRepository = HiveShopRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
      deleteHiveDataDirectory(dataDirectoryName);
    });

    test('登録→IDで検索→削除', () async {
      // 関連データ登録
      final commodity = Commodity.create("a", QuantityType.gram());
      await commodityRepository.createCommodity(commodity);
      final shop = Shop.createByName("b");
      await shopRepository.createShop(shop);

      // 登録
      final purchaseResult = PurchaseResult.create(
          commodity: commodity,
          shop: shop,
          price: 100,
          quantity: 1,
          purchaseDate: DateTime.now());
      await repository.createPurchaseResult(purchaseResult);

      // IDで検索
      final storedPurchaseResult =
          await repository.getPurchaseResultById(purchaseResult.id);
      expect(storedPurchaseResult, purchaseResult);

      //削除
      await repository.deletePurchaseResult(purchaseResult);
      final storedPurchaseResult2 =
          await repository.getPurchaseResultById(purchaseResult.id);
      expect(storedPurchaseResult2, null);
    });

    test('複数登録→一覧取得→商品IDに紐付く一覧取得→商品IDに紐付く最新データ取得→商品IDに紐付く最安単価データ取得', () async {
      // 関連データ登録
      final commodity1 = Commodity.create("a", QuantityType.gram());
      final commodity2 = Commodity.create("b", QuantityType.gram());
      await commodityRepository.createCommodity(commodity1);
      await commodityRepository.createCommodity(commodity2);
      final shop = Shop.createByName("c");
      await shopRepository.createShop(shop);

      final now = DateTime.now();

      // 複数登録
      final purchaseResult1 = PurchaseResult.create(
          commodity: commodity1,
          shop: shop,
          price: 100,
          quantity: 1,
          purchaseDate: DateTime(now.year, now.month, now.day + 1));
      final purchaseResult2 = PurchaseResult.create(
          commodity: commodity2,
          shop: shop,
          price: 150,
          quantity: 1,
          purchaseDate: now);
      final purchaseResult3 = PurchaseResult.create(
          commodity: commodity1,
          shop: shop,
          price: 50,
          quantity: 1,
          purchaseDate: DateTime(now.year, now.month, now.day - 1));
      await repository.createPurchaseResult(purchaseResult1);
      await repository.createPurchaseResult(purchaseResult2);
      await repository.createPurchaseResult(purchaseResult3);

      final allPurchaseResults = [
        purchaseResult1,
        purchaseResult2,
        purchaseResult3
      ] // id順にソート
        ..sort((c, n) => c.id.compareTo(n.id));

      // 一覧取得
      final storedAllPurchaseResults = await repository.getPurchaseResults();
      expect(storedAllPurchaseResults, allPurchaseResults);

      final purchaseResultsOfCommodity1 = [
        purchaseResult1,
        purchaseResult3
      ] // id順にソート
        ..sort((c, n) => c.id.compareTo(n.id));

      // 一覧取得
      final storedPurchaseResultsOfCommodity1 =
          await repository.getPurchaseResultsByCommodityId(commodity1.id);
      expect(storedPurchaseResultsOfCommodity1, purchaseResultsOfCommodity1);

      // 商品IDに紐付く最新データ取得
      final storedNewestPurchaseResultOfCommodity1 =
          await repository.getNewestPurchaseResultByCommodityId(commodity1.id);
      expect(storedNewestPurchaseResultOfCommodity1, purchaseResult1);

      // 商品IDに紐付く最安単価データ取得
      final storedMostInexpensivePurchaseResultOfCommodity1 = await repository
          .getMostInexpensivePurchaseResultPerUnitByCommodityId(commodity1.id);
      expect(storedMostInexpensivePurchaseResultOfCommodity1, purchaseResult3);
    });
  });
}
