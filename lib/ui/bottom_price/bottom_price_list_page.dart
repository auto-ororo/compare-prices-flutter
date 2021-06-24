import 'package:compare_prices/main.dart';
import 'package:compare_prices/ui/bottom_price/bottom_price_row.dart';
import 'package:compare_prices/ui/common/search_text_field.dart';
import 'package:compare_prices/ui/common/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bottom_price_list_page_view_model.dart';

class BottomPriceListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final searchWord = useProvider(bottomPriceListPageViewModelProvider
        .select((value) => value.searchWord));

    final bottomPrices = useProvider(bottomPriceListPageViewModelProvider
        .select((value) => value.bottomPrices));
    final filteredBottomPrices = useProvider(
        bottomPriceListPageViewModelProvider
            .select((value) => value.filteredBottomPrices));
    final viewModel =
        useProvider(bottomPriceListPageViewModelProvider.notifier);

    final textEditingController = useTextEditingController();
    final debouncer = Debouncer(milliseconds: 250);

    useEffect(() {
      // 初期処理
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        viewModel.getList();

        viewModel.errorMessage.stream.listen((errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        });
      });

      return () {};
    }, const []);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        print("execute filter list");
        viewModel.filter();
      });
      return () => {};
    }, [searchWord, bottomPrices]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('底値リスト'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SearchTextField(
              controller: textEditingController,
              labelText: "検索",
              hintText: "商品名、店舗名を入力下ください。",
              onChanged: (word) {
                debouncer.run(() => viewModel.updateSearchWord(word));
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: filteredBottomPrices.length,
                itemBuilder: (context, index) {
                  final row = filteredBottomPrices[index];
                  return BottomPriceRow(row, () {
                    print("${row.commodity.name} Tapped!!");
                  });
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context)
                .pushNamed(RouteName.createPurchaseResultPage);
            viewModel.getList();
          }),
    );
  }
}
