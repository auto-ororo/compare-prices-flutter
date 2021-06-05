import 'package:compare_prices/data/base/result.dart';
import 'package:compare_prices/data/example/example_repository.dart';

class SecondExampleRepository extends ExampleRepository {
  @override
  Future<Result<String>> getExampleWord() async {
    await Future.delayed(Duration(seconds: 5));
    return Result.success("fetched word2");
  }
}
