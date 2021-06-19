import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity_row.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getInexpensiveCommodityListUseCaseProvider =
    Provider.autoDispose<GetInexpensiveCommodityListUseCase>(
        (ref) => GetInexpensiveCommodityListUseCase(ref.read));

class GetInexpensiveCommodityListUseCase
    extends FutureUseCase<List<CommodityRow>, NoParam> {
  final Reader _reader;

  late final CommodityRepository _commodityRepository =
      _reader(commodityRepositoryProvider);
  late final ShopRepository _shopRepository = _reader(shopRepositoryProvider);
  late final PurchaseResultRepository _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  GetInexpensiveCommodityListUseCase(this._reader);

  @override
  Future<Result<List<CommodityRow>>> call(NoParam params) {
    return Result.guardFuture(() async {
      final commodities = await _commodityRepository.getEnabledCommodities();

      var index = 0;

      var list = <CommodityRow>[];

      for (final element in commodities) {
        final purchaseResult = await _purchaseResultRepository
            .getEnabledMostInexpensivePurchaseResultByCommodityId(element.id);

        if (purchaseResult == null) continue;

        final shop =
            await _shopRepository.getEnabledShopById(purchaseResult.shopId);

        if (shop == null) continue;

        final newestPurchaseResult = await _purchaseResultRepository
            .getEnabledNewestPurchaseResultByCommodityId(element.id);

        if (newestPurchaseResult == null) continue;

        final row = CommodityRow(
            id: index.toString(),
            commodity: element,
            mostInexpensiveShop: shop,
            price: purchaseResult.price,
            purchaseDate: newestPurchaseResult.purchaseDate);

        index++;
        list.add(row);
      }
      return list;
    });
  }
}
