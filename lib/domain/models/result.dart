import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const Result._();
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Exception exception) = Failure<T>;

  static Result<T> guard<T>(T Function() body) {
    try {
      return Result.success(body());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  static Future<Result<T>> guardFuture<T>(Future<T> Function() future) async {
    try {
      return Result.success(await future());
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  bool get isSuccess => when(success: (data) => true, failure: (e) => false);

  bool get isFailure => !isSuccess;

  T get dataOrThrow {
    return when(
      success: (data) => data,
      failure: (e) => throw e,
    );
  }
}
