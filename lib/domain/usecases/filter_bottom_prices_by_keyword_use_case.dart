import 'package:compare_prices/domain/models/bottom_price.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'filter_bottom_prices_by_keyword_use_case.freezed.dart';

final filterBottomPricesByKeywordUseCaseProvider =
    Provider.autoDispose<FilterBottomPricesByKeywordUseCase>(
        (ref) => FilterBottomPricesByKeywordUseCase());

class FilterBottomPricesByKeywordUseCase extends UseCase<List<BottomPrice>,
    FilterBottomPricesByKeywordUseCaseParams> {
  FilterBottomPricesByKeywordUseCase();

  @override
  Result<List<BottomPrice>> call(
      FilterBottomPricesByKeywordUseCaseParams params) {
    return Result.guard(() {
      if (params.keyword == "") {
        return params.bottomPrices;
      }

      return params.bottomPrices
          .where((element) =>
              (element.commodity.name.contains(params.keyword) ||
                  (element.mostInexpensiveShop.name.contains(params.keyword))))
          .toList();
    });
  }
}

@freezed
class FilterBottomPricesByKeywordUseCaseParams
    with _$FilterBottomPricesByKeywordUseCaseParams {
  const factory FilterBottomPricesByKeywordUseCaseParams({
    required List<BottomPrice> bottomPrices,
    required String keyword,
  }) = _FilterBottomPricesByKeywordUseCaseParams;
}
