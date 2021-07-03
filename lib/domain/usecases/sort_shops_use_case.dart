import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/entities/shop_sort_type.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'sort_shops_use_case.freezed.dart';

final sortShopsUseCaseProvider =
    Provider.autoDispose<SortShopsUseCase>((ref) => SortShopsUseCase());

class SortShopsUseCase extends UseCase<List<Shop>, SortShopsUseCaseParams> {
  SortShopsUseCase();

  @override
  Result<List<Shop>> call(SortShopsUseCaseParams params) {
    return Result.guard(() {
      final list = params.shops.toList();
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
class SortShopsUseCaseParams with _$SortShopsUseCaseParams {
  const factory SortShopsUseCaseParams({
    required List<Shop> shops,
    required ShopSortType sortType,
  }) = _SortShopsUseCaseParams;
}
