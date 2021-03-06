import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/result.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'create_commodity_use_case.freezed.dart';

final createCommodityUseCaseProvider =
    Provider.autoDispose<CreateCommodityUseCase>(
        (ref) => CreateCommodityUseCase(ref.read));

class CreateCommodityUseCase
    extends FutureUseCase<Commodity, CreateCommodityUseCaseParams> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);

  CreateCommodityUseCase(this._reader);

  @override
  Future<Result<Commodity>> call(CreateCommodityUseCaseParams params) {
    return Result.guardFuture(() async {
      // 同名の商品名が存在した場合はエラー
      if (await _commodityRepository.getCommodityByName(params.name) != null) {
        throw DomainException(ExceptionType.alreadyExists());
      }

      final commodity = Commodity.create(params.name, params.quantityType);

      _commodityRepository.createCommodity(commodity);

      return commodity;
    });
  }
}

@freezed
class CreateCommodityUseCaseParams with _$CreateCommodityUseCaseParams {
  const factory CreateCommodityUseCaseParams({
    required String name,
    required QuantityType quantityType,
  }) = _CreateCommodityUseCaseParams;
}
