import 'package:compare_prices/domain/entities/commodity_row.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'filter_inexpensive_commodity_list_by_keyword_use_case.freezed.dart';

final filterInexpensiveCommodityListByKeywordUseCaseProvider =
    Provider.autoDispose<FilterInexpensiveCommodityListByKeywordUseCase>(
        (ref) => FilterInexpensiveCommodityListByKeywordUseCase());

class FilterInexpensiveCommodityListByKeywordUseCase extends UseCase<
    List<CommodityRow>, FilterInexpensiveCommodityListByKeywordUseCaseParams> {
  FilterInexpensiveCommodityListByKeywordUseCase();

  @override
  Result<List<CommodityRow>> call(
      FilterInexpensiveCommodityListByKeywordUseCaseParams params) {
    return Result.guard(() {
      if (params.keyword == "") {
        return params.list;
      }

      return params.list
          .where((element) =>
              (element.commodity.name.contains(params.keyword) ||
                  (element.mostInexpensiveShop.name.contains(params.keyword))))
          .toList();
    });
  }
}

@freezed
class FilterInexpensiveCommodityListByKeywordUseCaseParams
    with _$FilterInexpensiveCommodityListByKeywordUseCaseParams {
  const factory FilterInexpensiveCommodityListByKeywordUseCaseParams({
    required List<CommodityRow> list,
    required String keyword,
  }) = _FilterInexpensiveCommodityListByKeywordUseCaseParams;
}
