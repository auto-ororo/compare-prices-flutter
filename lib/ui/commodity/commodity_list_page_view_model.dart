import 'dart:math';

import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/entities/commodity_row.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page_state.dart';
import 'package:english_words/english_words.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

class CommodityListPageViewModel extends StateNotifier<CommodityListPageState> {
  CommodityListPageViewModel() : super(const CommodityListPageState());

  void getList() {
    var commodityRows = List<CommodityRow>.generate(50, (_) {
      final id = Uuid().v4.toString();
      final datetime = DateTime.now();
      final commodity = Commodity(
          id: Uuid().v4.toString(),
          name: WordPair.random().asPascalCase,
          createdAt: datetime,
          updatedAt: datetime);
      final shop = Shop(
          id: Uuid().v4.toString(),
          name: WordPair.random().asPascalCase,
          createdAt: datetime,
          updatedAt: datetime);
      final price = Random().nextInt(1000);

      return CommodityRow(
          id: id,
          commodity: commodity,
          mostInexpensiveShop: shop,
          price: price,
          purchaseDate: datetime);
    }).toList();
    state = state.copyWith(commodityRows: commodityRows);
  }

  void shuffleList() {
    var commodityRows = state.commodityRows;
    commodityRows.shuffle();
    state = state.copyWith(commodityRows: commodityRows);
  }

  void sort() {
    var list = state.commodityRows;
    list.sort((a, b) => a.commodity.name.compareTo(b.commodity.name));
    state = state.copyWith(filteredCommodityRows: list);
  }

  void bindSearchWord(String word) {
    state = state.copyWith(searchWord: word);
  }

  void filter() {
    if (state.searchWord == "") {
      state = state.copyWith(filteredCommodityRows: state.commodityRows);
      return;
    }

    var list = state.commodityRows
        .where((element) => element.commodity.name.contains(state.searchWord))
        .toList();

    state = state.copyWith(filteredCommodityRows: list);
  }
}
