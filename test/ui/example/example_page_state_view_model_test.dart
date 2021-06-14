import 'package:compare_prices/domain/entities/result.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';
import 'package:compare_prices/ui/example/example_page_state.dart';
import 'package:compare_prices/ui/example/example_page_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'example_page_state_view_model_test.mocks.dart';

@GenerateMocks([ExampleRepository])
void main() {
  group('ExamplePageViewModel', () {
    final repository = MockExampleRepository();

    final viewModel = ExamplePageViewModel(repository);

    test('returns word if fetchWord was success', () async {
      final listener = Listener();

      when(repository.getExampleWord())
          .thenAnswer((realInvocation) async => Result.success("word"));

      viewModel.addListener(listener);

      await viewModel.fetchWordFromRepository();

      verify(listener(ExamplePageState(counter: 0, fetchedWord: "Fetching...")))
          .called(1);

      verify(listener(ExamplePageState(counter: 0, fetchedWord: "word")))
          .called(1);
    });

    test('throw error if fetchWord was failure', () async {
      final listener = Listener();

      final error = Exception();

      when(repository.getExampleWord())
          .thenAnswer((realInvocation) async => Result.failure(error));

      viewModel.addListener(listener);

      await viewModel.fetchWordFromRepository();

      verify(listener(ExamplePageState(
              counter: 0,
              fetchedWord: "Fetching...",
              errorMessage: error.toString())))
          .called(1);
    });
  });
}

class Listener extends Mock {
  void call(ExamplePageState value);
}
