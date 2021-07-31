import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/exception/has_exception_type.dart';

extension ExceptionExtension on Exception {
  ExceptionType exceptionType() {
    if (this is HasExceptionType) {
      return (this as HasExceptionType).exceptionType();
    } else {
      return ExceptionType.unknown(this.toString());
    }
  }
}
