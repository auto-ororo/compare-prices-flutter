import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import 'home_page_state.dart';

final homePageViewModelProvider =
    StateNotifierProvider.autoDispose<HomePageViewModel, HomePageState>(
        (_) => HomePageViewModel());

class HomePageViewModel extends StateNotifier<HomePageState> {
  void updateNavigationIndex(int index) {
    state = state.copyWith(navigationIndex: index);
  }

  HomePageViewModel() : super(const HomePageState());
}
