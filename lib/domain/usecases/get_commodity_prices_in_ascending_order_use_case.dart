import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity_price.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

final getCommodityPricesInAscendingOrderUseCaseProvider =
    Provider.autoDispose<GetCommodityPricesInAscendingOrderUseCase>(
        (ref) => GetCommodityPricesInAscendingOrderUseCase(ref.read));

class GetCommodityPricesInAscendingOrderUseCase
    extends FutureUseCase<List<CommodityPrice>, String> {
  final Reader _reader;

  late final _purchaseResultRepository =
      _reader(purchaseResultRepositoryProvider);

  GetCommodityPricesInAscendingOrderUseCase(this._reader);

  @override
  Future<Result<List<CommodityPrice>>> call(String params) {
    return Result.guardFuture(() async {
      final purchaseResults = await _purchaseResultRepository
          .getEnabledPurchaseResultsByCommodityId(params);

      purchaseResults.sort((c, n) => c.unitPrice.compareTo(n.unitPrice));

      final list = <CommodityPrice>[];

      var rank = 1;
      for (final element in purchaseResults) {
        if (!element.shop.isEnabled) continue;

        final commodityPrice = CommodityPrice(
            id: Uuid().v4(),
            commodityId: params,
            purchaseResultId: element.id,
            rank: rank,
            count: element.count,
            totalPrice: element.totalPrice,
            unitPrice: element.unitPrice,
            shop: element.shop,
            purchaseDate: element.purchaseDate);

        list.add(commodityPrice);
        rank++;
      }

      return list;
    });
  }
}
