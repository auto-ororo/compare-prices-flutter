import 'package:compare_prices/data/base/result.dart';
import 'package:compare_prices/data/example/example_repository.dart';

class FirstExampleRepository extends ExampleRepository {
  @override
  Future<Result<String>> getExampleWord() async {
    return Result.success("fetched word1");
  }
}
