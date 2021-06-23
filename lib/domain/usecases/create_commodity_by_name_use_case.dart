import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final createCommodityByNameUseCaseProvider =
    Provider.autoDispose<CreateCommodityByNameUseCase>(
        (ref) => CreateCommodityByNameUseCase(ref.read));

class CreateCommodityByNameUseCase extends FutureUseCase<void, String> {
  final Reader _reader;

  late final CommodityRepository _commodityRepository =
      _reader(commodityRepositoryProvider);

  CreateCommodityByNameUseCase(this._reader);

  @override
  Future<Result<void>> call(String params) {
    return Result.guardFuture(() async {
      // 同名の商品名が存在した場合はエラー
      if (await _commodityRepository.getEnabledCommodityByName(params) !=
          null) {
        throw DomainException("すでにそんざいしてます");
      }

      final commodity = Commodity.createByName(params);

      _commodityRepository.createCommodity(commodity);
    });
  }
}
