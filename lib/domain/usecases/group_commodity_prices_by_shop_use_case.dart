import 'package:compare_prices/domain/entities/commodity_price.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final groupCommodityPricesByShopUseCaseProvider =
    Provider.autoDispose<GroupCommodityPricesByShopUseCase>(
        (ref) => GroupCommodityPricesByShopUseCase());

class GroupCommodityPricesByShopUseCase
    extends UseCase<List<CommodityPrice>, List<CommodityPrice>> {
  GroupCommodityPricesByShopUseCase();

  @override
  Result<List<CommodityPrice>> call(List<CommodityPrice> params) {
    return Result.guard(() {
      final list = <CommodityPrice>[];
      final shops = <Shop>[];

      for (final element in params) {
        if (!shops.contains(element.shop)) {
          list.add(element);
          shops.add(element.shop);
        }
      }

      return list;
    });
  }
}
