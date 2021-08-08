import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/domain/usecases/create_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/create_purchase_result_use_case.dart';
import 'package:compare_prices/domain/usecases/create_shop_by_name_use_case.dart';
import 'package:compare_prices/domain/usecases/delete_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/delete_purchase_result_by_id_use_case.dart';
import 'package:compare_prices/domain/usecases/delete_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_bottom_prices_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_commodities_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/filter_shops_by_keyword_use_case.dart';
import 'package:compare_prices/domain/usecases/get_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/get_commodity_prices_in_ascending_order_use_case.dart';
import 'package:compare_prices/domain/usecases/get_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/get_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/group_commodity_prices_by_shop_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_bottom_prices_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_commodities_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_purchase_results_use_case.dart';
import 'package:compare_prices/domain/usecases/sort_shops_use_case.dart';
import 'package:compare_prices/domain/usecases/update_commodity_use_case.dart';
import 'package:compare_prices/domain/usecases/update_shop_use_case.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  CommodityRepository,
  ShopRepository,
  PurchaseResultRepository,
  InfrastructureConfigRepository,
  CreateCommodityUseCase,
  UpdateCommodityUseCase,
  GetCommoditiesUseCase,
  DeleteCommodityUseCase,
  FilterCommoditiesByKeywordUseCase,
  SortCommoditiesUseCase,
  CreateShopByNameUseCase,
  UpdateShopUseCase,
  GetShopsUseCase,
  DeleteShopUseCase,
  FilterShopsByKeywordUseCase,
  SortShopsUseCase,
  GetBottomPricesUseCase,
  FilterBottomPricesByKeywordUseCase,
  SortBottomPricesUseCase,
  CreatePurchaseResultUseCase,
  GetPurchaseResultsUseCase,
  SortPurchaseResultsUseCase,
  DeletePurchaseResultByIdUseCase,
  GetCommodityPricesInAscendingOrderUseCase,
  GroupCommodityPricesByShopUseCase
])
Future<void> main() async {}
