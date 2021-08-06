import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'filter_commodities_by_keyword_use_case.freezed.dart';

final filterCommoditiesByKeywordUseCaseProvider =
    Provider.autoDispose<FilterCommoditiesByKeywordUseCase>(
        (ref) => FilterCommoditiesByKeywordUseCase());

class FilterCommoditiesByKeywordUseCase
    extends UseCase<List<Commodity>, FilterCommoditiesByKeywordUseCaseParams> {
  FilterCommoditiesByKeywordUseCase();

  @override
  Result<List<Commodity>> call(FilterCommoditiesByKeywordUseCaseParams params) {
    return Result.guard(() {
      if (params.keyword == "") {
        return params.commodities;
      }

      return params.commodities
          .where((element) => element.name.contains(params.keyword))
          .toList();
    });
  }
}

@freezed
class FilterCommoditiesByKeywordUseCaseParams
    with _$FilterCommoditiesByKeywordUseCaseParams {
  const factory FilterCommoditiesByKeywordUseCaseParams({
    required List<Commodity> commodities,
    required String keyword,
  }) = _FilterCommoditiesByKeywordUseCaseParams;
}
