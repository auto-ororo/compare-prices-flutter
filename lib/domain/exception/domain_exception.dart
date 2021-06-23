import 'package:compare_prices/domain/entities/has_message.dart';

class DomainException implements Exception, HasMessage {
  final String errorMessage;

  DomainException(this.errorMessage);

  @override
  String message() {
    return errorMessage;
  }
}
