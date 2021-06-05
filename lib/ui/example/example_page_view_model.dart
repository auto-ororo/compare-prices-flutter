import 'package:compare_prices/ui/example/example_page_state.dart';
import 'package:state_notifier/state_notifier.dart';

class ExamplePageViewModel extends StateNotifier<ExamplePageState> {
  ExamplePageViewModel() : super(const ExamplePageState());

  void incrementCounter() {
    state = state.copyWith(counter: state.counter + 1);
  }

  void decrementCounter() {
    state = state.copyWith(counter: state.counter - 1);
  }

  void clearCounter() {
    state = state.copyWith(counter: 0);
  }
}
