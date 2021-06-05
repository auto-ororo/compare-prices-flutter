import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_page_state.freezed.dart';

@freezed
class ExamplePageState with _$ExamplePageState {
  const factory ExamplePageState({
    @Default(0) int counter,
  }) = _ExamplePageState;
}
