// import 'package:compare_prices/data/providers.dart';
// import 'package:compare_prices/domain/models/result.dart';
// import 'package:compare_prices/domain/repositories/example_repository.dart';
// import 'package:compare_prices/ui/example/example_page_state.dart';
// import 'package:compare_prices/ui/example/example_page_view_model.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// import 'example_page_state_view_model_test.mocks.dart';
//
// @GenerateMocks([ExampleRepository])
// void main() {
//   group('ExamplePageViewModel', () {
//     final repository = MockExampleRepository();
//
//     test('returns word if fetchWord was success', () async {
//       final container = ProviderContainer(overrides: [
//         exampleRepositoryProvider.overrideWithProvider(
//           Provider.autoDispose<ExampleRepository>((ref) => repository),
//         )
//       ]);
//       addTearDown(container.dispose);
//       final viewModel = ExamplePageViewModel(container.read);
//
//       final listener = Listener();
//
//       when(repository.getExampleWord())
//           .thenAnswer((realInvocation) async => Result.success("word"));
//
//       viewModel.addListener(listener);
//
//       await viewModel.fetchWordFromRepository();
//
//       verify(listener(ExamplePageState(counter: 0, fetchedWord: "Fetching...")))
//           .called(1);
//
//       verify(listener(ExamplePageState(counter: 0, fetchedWord: "word")))
//           .called(1);
//     });
//
//     test('throw error if fetchWord was failure', () async {
//       final container = ProviderContainer(overrides: [
//         exampleRepositoryProvider.overrideWithProvider(
//           Provider.autoDispose<ExampleRepository>((ref) => repository),
//         )
//       ]);
//       addTearDown(container.dispose);
//       final viewModel = ExamplePageViewModel(container.read);
//
//       final listener = Listener();
//
//       final error = Exception();
//
//       when(repository.getExampleWord())
//           .thenAnswer((realInvocation) async => Result.failure(error));
//
//       viewModel.addListener(listener);
//
//       await viewModel.fetchWordFromRepository();
//
//       verify(listener(ExamplePageState(
//               counter: 0,
//               fetchedWord: "Fetching...",
//               errorMessage: error.toString())))
//           .called(1);
//     });
//   });
// }
//
// class Listener extends Mock {
//   void call(ExamplePageState value);
// }
