import 'package:compare_prices/domain/exception/domain_exception.dart';
import 'package:compare_prices/domain/exception/exception_extensions.dart';
import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExceptionExtensions', () {
    group('exceptionType', () {
      test('HasExceptionTypeを継承している場合、特定のExceptionTypeになること', () {
        final Exception exception = DomainException(ExceptionType.notFound());

        expect(exception.exceptionType(), ExceptionType.notFound());
      });

      test('HasExceptionTypeを継承していない場合、UnknownTypeになること', () {
        final Exception exception = Exception();

        expect(exception.exceptionType(),
            ExceptionType.unknown(exception.toString()));
      });
    });
  });
}
