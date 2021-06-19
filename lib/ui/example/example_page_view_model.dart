import 'package:compare_prices/data/providers.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';
import 'package:compare_prices/ui/example/example_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

final examplePageViewModelProvider =
    StateNotifierProvider.autoDispose<ExamplePageViewModel, ExamplePageState>(
        (ref) => ExamplePageViewModel(ref.read));

class ExamplePageViewModel extends StateNotifier<ExamplePageState> {
  final Reader _reader;

  late final ExampleRepository _repository = _reader(exampleRepositoryProvider);

  ExamplePageViewModel(this._reader) : super(const ExamplePageState());

  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  void decrementCounter() {
    state = state.copyWith(counter: state.counter - 1);
  }

  void clearCounter() {
    state = state.copyWith(counter: 0);
  }

  void clearWord() {
    state = state.copyWith(fetchedWord: "");
  }

  Future<void> fetchWordFromRepository() {
    state = state.copyWith(fetchedWord: "Fetching...");
    return _repository.getExampleWord().then((result) {
      return result.when(success: (word) {
        state = state.copyWith(fetchedWord: word);
      }, failure: (error) {
        state = state.copyWith(errorMessage: error.toString());
      });
    });
  }
}
