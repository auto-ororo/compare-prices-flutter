import 'package:compare_prices/domain/entities/has_message.dart';

extension ExceptionExtension on Exception {
  String errorMessage() {
    if (this is HasMessage) {
      return (this as HasMessage).message();
    } else {
      return this.toString();
    }
  }
}
