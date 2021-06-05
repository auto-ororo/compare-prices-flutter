import '../base/result.dart';

abstract class ExampleRepository {
  Future<Result<String>> getExampleWord();
}
