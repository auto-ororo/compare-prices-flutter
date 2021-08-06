import 'package:compare_prices/data/commodity/hive_commodity_repository.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../hive_helper.dart';

void main() async {
  final dataDirectoryName = 'HiveCommodityRepositoryTest';
  await initialiseHive(dataDirectoryName);

  group('HiveCommodityRepository', () {
    late HiveCommodityRepository repository;

    setUp(() {
      repository = HiveCommodityRepository();
    });

    tearDown(() async {
      await Hive.deleteFromDisk();
      deleteHiveDataDirectory(dataDirectoryName);
    });

    test('登録→IDで検索→更新→削除', () async {
      // 登録
      final commodity = Commodity.create("a", QuantityType.count());
      await repository.createCommodity(commodity);

      // IDで検索
      final storedCommodity = await repository.getCommodityById(commodity.id);
      expect(storedCommodity, commodity);

      //更新
      final editedCommodity = commodity.copyWith(name: "b");
      await repository.createCommodity(editedCommodity);
      final storedCommodity2 = await repository.getCommodityById(commodity.id);
      expect(storedCommodity2, editedCommodity);

      //削除
      await repository.deleteCommodity(editedCommodity);
      final storedCommodity3 = await repository.getCommodityById(commodity.id);
      expect(storedCommodity3, null);
    });

    test('登録→名前で検索(完全一致)', () async {
      // 登録
      final commodity = Commodity.create("abc", QuantityType.count());
      await repository.createCommodity(commodity);

      // 名前検索(完全一致)
      final storedCommodity = await repository.getCommodityByName("abc");
      expect(storedCommodity, commodity);

      // 名前検索(部分一致)
      final storedCommodity2 = await repository.getCommodityByName("ab");
      expect(storedCommodity2, null);
    });

    test('複数登録→一覧取得', () async {
      // 登録
      final commodity1 = Commodity.create("a", QuantityType.count());
      final commodity2 = Commodity.create("b", QuantityType.gram());
      await repository.createCommodity(commodity1);
      await repository.createCommodity(commodity2);

      final commodities = [commodity1, commodity2]
        // id順にソート
        ..sort((c, n) => c.id.compareTo(n.id));

      // 一覧取得
      final storedCommodities = await repository.getCommodities();
      expect(storedCommodities, commodities);
    });
  });
}
