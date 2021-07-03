import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/bottom_price.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getBottomPricesUseCaseProvider =
    Provider.autoDispose<GetBottomPricesUseCase>(
        (ref) => GetBottomPricesUseCase(ref.read));

class GetBottomPricesUseCase extends FutureUseCase<List<BottomPrice>, NoParam> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);
  late final _shopRepository = _reader(shopRepositoryProvider);
  late final _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  GetBottomPricesUseCase(this._reader);

  @override
  Future<Result<List<BottomPrice>>> call(NoParam params) {
    return Result.guardFuture(() async {
      final commodities = await _commodityRepository.getEnabledCommodities();

      var index = 0;

      var list = <BottomPrice>[];

      for (final element in commodities) {
        final purchaseResult = await _purchaseResultRepository
            .getEnabledMostInexpensivePurchaseResultPerUnitByCommodityId(
                element.id);

        if (purchaseResult == null) continue;

        final shop =
            await _shopRepository.getEnabledShopById(purchaseResult.shopId);

        if (shop == null) continue;

        final newestPurchaseResult = await _purchaseResultRepository
            .getEnabledNewestPurchaseResultByCommodityId(element.id);

        if (newestPurchaseResult == null) continue;

        final row = BottomPrice(
            id: index.toString(),
            commodity: element,
            mostInexpensiveShop: shop,
            unitPrice: purchaseResult.unitPrice,
            purchaseDate: newestPurchaseResult.purchaseDate);

        index++;
        list.add(row);
      }
      return list;
    });
  }
}
