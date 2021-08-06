import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:compare_prices/domain/repositories/infrastructure_config_repository.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:compare_prices/domain/usecases/create_commodity_use_case.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  CommodityRepository,
  ShopRepository,
  PurchaseResultRepository,
  InfrastructureConfigRepository,
  CreateCommodityUseCase
])
Future<void> main() async {}
