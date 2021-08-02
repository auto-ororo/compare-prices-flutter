import 'package:compare_prices/domain/models/result.dart';

abstract class UseCase<Type, Params> {
  Result<Type> call(Params params);
}

abstract class FutureUseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

class NoParam {}
