import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'filter_shops_by_keyword_use_case.freezed.dart';

final filterShopsByKeywordUseCaseProvider =
    Provider.autoDispose<FilterShopsByKeywordUseCase>(
        (ref) => FilterShopsByKeywordUseCase());

class FilterShopsByKeywordUseCase
    extends UseCase<List<Shop>, FilterShopsByKeywordUseCaseParams> {
  FilterShopsByKeywordUseCase();

  @override
  Result<List<Shop>> call(FilterShopsByKeywordUseCaseParams params) {
    return Result.guard(() {
      if (params.keyword == "") {
        return params.list;
      }

      return params.list
          .where((element) => element.name.contains(params.keyword))
          .toList();
    });
  }
}

@freezed
class FilterShopsByKeywordUseCaseParams
    with _$FilterShopsByKeywordUseCaseParams {
  const factory FilterShopsByKeywordUseCaseParams({
    required List<Shop> list,
    required String keyword,
  }) = _FilterShopsByKeywordUseCaseParams;
}
