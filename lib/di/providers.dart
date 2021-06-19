import 'package:compare_prices/data/commodity/sample_commodity_repository.dart';
import 'package:compare_prices/data/example/first_example_repository.dart';
import 'package:compare_prices/data/purchaseresult/sample_purchase_result_repository.dart';
import 'package:compare_prices/data/shop/sample_shop_repository.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/example_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/domain/usecases/filter_inexpensive_commodity_list_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_inexpensive_commodity_list_use_case.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page_state.dart';
import 'package:compare_prices/ui/commodity/commodity_list_page_view_model.dart';
import 'package:compare_prices/ui/example/example_page_state.dart';
import 'package:compare_prices/ui/example/example_page_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Repository
final exampleRepositoryProvider =
    Provider.autoDispose<ExampleRepository>((ref) => FirstExampleRepository());

final commodityRepositoryProvider = Provider.autoDispose<CommodityRepository>(
    (ref) => SampleCommodityRepository());

final shopRepositoryProvider =
    Provider.autoDispose<ShopRepository>((ref) => SampleShopRepository());

final purchaseResultRepositoryProvider =
    Provider.autoDispose<PurchaseResultRepository>(
        (ref) => SamplePurchaseResultRepository());

// ViewModel
final examplePageViewModelProvider =
    StateNotifierProvider.autoDispose<ExamplePageViewModel, ExamplePageState>(
        (ref) => ExamplePageViewModel(ref.read(exampleRepositoryProvider)));

final commodityListPageViewModelProvider =
    StateNotifierProvider<CommodityListPageViewModel, CommodityListPageState>(
        (ref) => CommodityListPageViewModel(
            ref.read(getInexpensiveCommodityListUseCaseProvider),
            ref.read(filterInexpensiveCommodityListByKeywordUseCaseProvider)));

// UseCase
final getInexpensiveCommodityListUseCaseProvider =
    Provider.autoDispose<GetInexpensiveCommodityListUseCase>((ref) =>
        GetInexpensiveCommodityListUseCase(
            ref.read(commodityRepositoryProvider),
            ref.read(shopRepositoryProvider),
            ref.read(purchaseResultRepositoryProvider)));

final filterInexpensiveCommodityListByKeywordUseCaseProvider =
    Provider.autoDispose<FilterInexpensiveCommodityListByKeywordUseCase>(
        (ref) => FilterInexpensiveCommodityListByKeywordUseCase());
