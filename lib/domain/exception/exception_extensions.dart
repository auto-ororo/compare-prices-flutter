import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/exception/has_exception_type.dart';

extension ExceptionExtension on Exception {
  // String errorMessage() {
  //   if (this is HasMessage) {
  //     return (this as HasMessage).message();
  //   } else {
  //     return this.toString();
  //   }
  // }

  ExceptionType exceptionType() {
    if (this is HasExceptionType) {
      return (this as HasExceptionType).exceptionType();
    } else {
      return ExceptionType.unknown(this.toString());
    }
  }
}
