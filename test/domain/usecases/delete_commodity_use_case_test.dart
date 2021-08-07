import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/usecases/delete_commodity_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helper.dart';
import '../../mocks/generate.mocks.dart';

void main() {
  group('DeleteCommodityUseCase', () {
    final repository = MockCommodityRepository();
    group('call', () {
      final commodity = Commodity.create("name", QuantityType.count());

      test('Paramのデータが削除されること', () async {
        final container =
            getDisposableProviderContainer(commodityRepository: repository);

        final useCase = DeleteCommodityUseCase(container.read);
        final result = await useCase(commodity);

        final capturedArgument = verify(repository.deleteCommodity(captureAny))
            .captured
            .first as Commodity;

        expect(result.isSuccess, true);
        expect(capturedArgument, commodity);
      });
    });
  });
}
