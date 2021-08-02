import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/commodity_sort_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'sort_commodities_use_case.freezed.dart';

final sortCommoditiesUseCaseProvider =
    Provider.autoDispose<SortCommoditiesUseCase>(
        (ref) => SortCommoditiesUseCase());

class SortCommoditiesUseCase
    extends UseCase<List<Commodity>, SortCommoditiesUseCaseParams> {
  SortCommoditiesUseCase();

  @override
  Result<List<Commodity>> call(SortCommoditiesUseCaseParams params) {
    return Result.guard(() {
      final list = params.commodities.toList();
      // Id順
      list.sort((c, n) => c.id.compareTo(n.id));

      params.sortType.when(name: () {
        // 名前昇順
        list.sort((c, n) => c.name.compareTo(n.name));
      }, oldestCreatedAt: () {
        // 追加日が新しい順
        list.sort((c, n) => c.createdAt.compareTo(n.createdAt));
      }, newestCreatedAt: () {
        // 追加日が古い順
        list.sort((n, c) => c.createdAt.compareTo(n.createdAt));
      });

      return list;
    });
  }
}

@freezed
class SortCommoditiesUseCaseParams with _$SortCommoditiesUseCaseParams {
  const factory SortCommoditiesUseCaseParams({
    required List<Commodity> commodities,
    required CommoditySortType sortType,
  }) = _SortCommoditiesUseCaseParams;
}
