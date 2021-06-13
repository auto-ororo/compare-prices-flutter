import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';

class FirstExampleRepository extends ExampleRepository {
  @override
  Future<Result<String>> getExampleWord() async {
    return Result.success("fetched word1");
  }
}
