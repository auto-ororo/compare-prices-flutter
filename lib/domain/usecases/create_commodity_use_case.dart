import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/quantity.dart';
import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/usecases/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'create_commodity_use_case.freezed.dart';

final createCommodityUseCaseProvider =
    Provider.autoDispose<CreateCommodityUseCase>(
        (ref) => CreateCommodityUseCase(ref.read));

class CreateCommodityUseCase
    extends FutureUseCase<void, CreateCommodityUseCaseParams> {
  final Reader _reader;

  late final _commodityRepository = _reader(commodityRepositoryProvider);

  CreateCommodityUseCase(this._reader);

  @override
  Future<Result<void>> call(CreateCommodityUseCaseParams params) {
    return Result.guardFuture(() async {
      // 同名の商品名が存在した場合はエラー
      if (await _commodityRepository.getEnabledCommodityByName(params.name) !=
          null) {
        throw DomainException(ExceptionType.alreadyExists());
      }

      final commodity = Commodity.create(params.name, params.quantity);

      _commodityRepository.createCommodity(commodity);
    });
  }
}

@freezed
class CreateCommodityUseCaseParams with _$CreateCommodityUseCaseParams {
  const factory CreateCommodityUseCaseParams({
    required String name,
    required Quantity quantity,
  }) = _CreateCommodityUseCaseParams;
}
