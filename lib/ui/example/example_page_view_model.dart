import 'package:compare_prices/data/example/example_repository.dart';
import 'package:compare_prices/di/providers.dart';
import 'package:compare_prices/ui/example/example_page_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class ExamplePageViewModel extends StateNotifier<ExamplePageState> {
  ExamplePageViewModel(this._reader) : super(const ExamplePageState());

  final Reader _reader;

  late final ExampleRepository _repository = _reader(exampleRepositoryProvider);

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
        throw error;
      });
    });
  }
}
