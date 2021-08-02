import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/bottom_price_sort_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'sort_bottom_prices_use_case.freezed.dart';

final sortBottomPricesUseCaseProvider =
    Provider.autoDispose<SortBottomPricesUseCase>(
        (ref) => SortBottomPricesUseCase());

class SortBottomPricesUseCase
    extends UseCase<List<BottomPrice>, SortBottomPricesUseCaseParams> {
  SortBottomPricesUseCase();

  @override
  Result<List<BottomPrice>> call(SortBottomPricesUseCaseParams params) {
    return Result.guard(() {
      final list = params.bottomPrices.toList();
      // Id順
      list.sort((c, n) => c.id.compareTo(n.id));

      params.sortType.when(commodity: () {
        // 商品名昇順
        list.sort((c, n) => c.commodity.name.compareTo(n.commodity.name));
      }, shop: () {
        // 店舗名昇順
        list.sort((c, n) =>
            c.mostInexpensiveShop.name.compareTo(n.mostInexpensiveShop.name));
      }, price: () {
        // 単価昇順
        list.sort((c, n) => c.unitPrice.compareTo(n.unitPrice));
      }, oldestPurchaseDate: () {
        // しばらく買っていない商品順
        list.sort((c, n) => c.purchaseDate.compareTo(n.purchaseDate));
      }, newestPurchaseDate: () {
        // 最近買った商品順
        list.sort((n, c) => c.purchaseDate.compareTo(n.purchaseDate));
      });
      return list;
    });
  }
}

@freezed
class SortBottomPricesUseCaseParams with _$SortBottomPricesUseCaseParams {
  const factory SortBottomPricesUseCaseParams({
    required List<BottomPrice> bottomPrices,
    required BottomPriceSortType sortType,
  }) = _SortBottomPricesUseCaseParams;
}
