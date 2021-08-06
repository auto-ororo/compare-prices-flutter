import 'package:compare_prices/domain/models/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    group('guard', () {
      test('Exceptionが発生しない場合、Successとなること', () {
        final successWord = "success";
        final result = Result.guard(() => successWord);
        expect(result, Result.success(successWord));
      });

      test('Exceptionが発生する場合、Failureとなること', () {
        final exception = Exception();
        final result = Result.guard(() {
          throw exception;
        });
        expect(result, Result.failure(exception));
      });
    });

    group('guardFuture', () {
      test('Exceptionが発生しない場合、Successとなること', () async {
        final successWord = "success";
        final result = await Result.guardFuture(() async {
          return successWord;
        });
        expect(result, Result.success(successWord));
      });

      test('Exceptionが発生する場合、Failureとなること', () async {
        final exception = Exception();
        final result = await Result.guardFuture(() async {
          throw exception;
        });
        expect(result, Result.failure(exception));
      });
    });

    group('isSuccess', () {
      test('Successの場合、trueになること', () {
        expect(Result.success("").isSuccess, true);
      });

      test('Failureの場合、falseになること', () {
        expect(Result.failure(Exception()).isSuccess, false);
      });
    });

    group('isFailure', () {
      test('Successの場合、falseになること', () {
        expect(Result.success("").isFailure, false);
      });

      test('Failureの場合、trueになること', () {
        expect(Result.failure(Exception()).isFailure, true);
      });
    });

    group('dataOrThrow', () {
      test('Successの場合、値が取得できること', () {
        final successData = "success";
        expect(Result.success(successData).dataOrThrow, successData);
      });

      test('Failureの場合、例外が発生すること', () {
        final exception = Exception();
        expect(() => Result.failure(exception).dataOrThrow, throwsA(exception));
      });
    });
  });
}
