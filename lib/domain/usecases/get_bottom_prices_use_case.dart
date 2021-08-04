import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getBottomPricesUseCaseProvider =
    Provider.autoDispose<GetBottomPricesUseCase>(
        (ref) => GetBottomPricesUseCase(ref.read));

class GetBottomPricesUseCase extends FutureUseCase<List<BottomPrice>, NoParam> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);
  late final _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  GetBottomPricesUseCase(this._reader);

  @override
  Future<Result<List<BottomPrice>>> call(NoParam params) {
    return Result.guardFuture(() async {
      final commodities = await _commodityRepository.getCommodities();

      var index = 0;

      var list = <BottomPrice>[];

      for (final element in commodities) {
        final purchaseResult = await _purchaseResultRepository
            .getMostInexpensivePurchaseResultPerUnitByCommodityId(element.id);

        if (purchaseResult == null) continue;

        final newestPurchaseResult = await _purchaseResultRepository
            .getNewestPurchaseResultByCommodityId(element.id);

        if (newestPurchaseResult == null) continue;

        final row = BottomPrice(
            id: index.toString(),
            commodity: element,
            mostInexpensiveShop: purchaseResult.shop,
            price: purchaseResult.price,
            unitPrice: purchaseResult.unitPrice(),
            quantity: purchaseResult.quantity,
            purchaseDate: newestPurchaseResult.purchaseDate);

        index++;
        list.add(row);
      }
      return list;
    });
  }
}
