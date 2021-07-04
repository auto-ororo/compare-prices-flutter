import 'package:freezed_annotation/freezed_annotation.dart';

part 'exception_type.freezed.dart';

@freezed
class ExceptionType<T> with _$ExceptionType<T> {
  const factory ExceptionType.alreadyExists() = _alreadyExists;
  const factory ExceptionType.notFound() = _notFound;
  const factory ExceptionType.unknown(String message) = _unknown;
}
