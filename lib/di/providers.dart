import 'package:compare_prices/data/example/example_repository.dart';
import 'package:compare_prices/data/example/second_example_repository.dart';
import 'package:compare_prices/ui/example/example_page_state.dart';
import 'package:compare_prices/ui/example/example_page_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ViewModel

final examplePageViewModelProvider =
    StateNotifierProvider.autoDispose<ExamplePageViewModel, ExamplePageState>(
        (ref) => ExamplePageViewModel(ref.read));

// Repository

final exampleRepositoryProvider =
    Provider<ExampleRepository>((ref) => SecondExampleRepository());
