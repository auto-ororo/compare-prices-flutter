import 'package:compare_prices/data/shop/hive_shop_repository.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../hive_helper.dart';

void main() async {
  final dataDirectoryName = 'HiveShopRepositoryTest';
  await initialiseHive(dataDirectoryName);

  group('HiveShopRepository', () {
    late HiveShopRepository repository;

    setUp(() {
      repository = HiveShopRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
      deleteHiveDataDirectory(dataDirectoryName);
    });

    test('登録→IDで検索→更新→削除', () async {
      // 登録
      final shop = Shop.createByName("a");
      await repository.createShop(shop);

      // IDで検索
      final storedShop = await repository.getShopById(shop.id);
      expect(storedShop, shop);

      //更新
      final editedShop = shop.copyWith(name: "b");
      await repository.updateShop(editedShop);
      final storedShop2 = await repository.getShopById(editedShop.id);
      expect(storedShop2, editedShop);

      //削除
      await repository.deleteShop(editedShop);
      final storedShop3 = await repository.getShopById(shop.id);
      expect(storedShop3, null);
    });

    test('登録→名前で検索(完全一致)', () async {
      // 登録
      final shop = Shop.createByName("abc");
      await repository.createShop(shop);

      // 名前検索(完全一致)
      final storedShop = await repository.getShopByName("abc");
      expect(storedShop, shop);

      // 名前検索(部分一致)
      final storedShop2 = await repository.getShopByName("ab");
      expect(storedShop2, null);
    });

    test('複数登録→一覧取得', () async {
      // 登録
      final shop1 = Shop.createByName("a");
      final shop2 = Shop.createByName("b");
      await repository.createShop(shop1);
      await repository.createShop(shop2);

      final shops = [shop1, shop2]
        // id順にソート
        ..sort((c, n) => c.id.compareTo(n.id));

      // 一覧取得
      final storedShops = await repository.getShops();
      expect(storedShops, shops);
    });
  });
}
