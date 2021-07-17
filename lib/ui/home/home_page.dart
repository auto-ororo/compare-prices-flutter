import 'package:compare_prices/ui/common/keep_alive_view_wrapper.dart';
import 'package:compare_prices/ui/home/home_page_view_model.dart';
import 'package:compare_prices/ui/price/bottom/bottom_price_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  final _pages = [
    KeepAliveViewWrapper(child: BottomPriceListPage()),
    Center(child: Text("履歴")),
    Center(child: Text("その他")),
  ];

  @override
  Widget build(context) {
    final navigationIndex = useProvider(
        homePageViewModelProvider.select((value) => value.navigationIndex));
    final viewModel = useProvider(homePageViewModelProvider.notifier);
    final pageController = usePageController();

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) => viewModel.updateNavigationIndex(index),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationIndex,
        onTap: (int index) {
          viewModel.updateNavigationIndex(index);
          pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.commonBottomPrice,
            icon: Icon(Icons.attach_money),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.commonHistory,
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.commonOther,
            icon: Icon(Icons.dehaze_sharp),
          ),
        ],
      ),
    );
  }
}
