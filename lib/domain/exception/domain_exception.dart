import 'package:compare_prices/domain/exception/exception_type.dart';
import 'package:compare_prices/domain/exception/has_exception_type.dart';

class DomainException implements Exception, HasExceptionType {
  ExceptionType _exceptionType;

  DomainException(this._exceptionType);

  @override
  ExceptionType exceptionType() {
    return _exceptionType;
  }
}
