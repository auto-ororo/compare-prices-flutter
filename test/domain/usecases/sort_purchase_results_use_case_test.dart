import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/purchase_result_sort_type.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:compare_prices/domain/usecases/sort_purchase_results_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortPurchaseResultsUseCase', () {
    group('call', () {
      final useCase = SortPurchaseResultsUseCase();

      final now = DateTime.now();

      final purchaseResult1 = PurchaseResult(
          id: "1",
          commodity: Commodity.create("a", QuantityType.count()),
          shop: Shop.createByName("a"),
          price: 100,
          quantity: 1,
          purchaseDate: DateTime(now.year, now.month, now.day - 1),
          createdAt: DateTime(now.year, now.month, now.day + 1),
          updatedAt: now);

      final purchaseResult2 = PurchaseResult(
          id: "2",
          commodity: Commodity.create("a", QuantityType.count()),
          shop: Shop.createByName("a"),
          price: 100,
          quantity: 1,
          purchaseDate: DateTime(now.year, now.month, now.day + 1),
          createdAt: DateTime(now.year, now.month, now.day - 1),
          updatedAt: now);

      final purchaseResult3 = PurchaseResult(
          id: "3",
          commodity: Commodity.create("a", QuantityType.count()),
          shop: Shop.createByName("a"),
          price: 100,
          quantity: 1,
          purchaseDate: now,
          createdAt: now,
          updatedAt: now);

      final purchaseResults = [
        purchaseResult1,
        purchaseResult2,
        purchaseResult3
      ];

      test('登録日降順', () async {
        final result = await useCase(SortPurchaseResultsUseCaseParams(
            purchaseResults: purchaseResults,
            sortType: PurchaseResultSortType.newestCreatedAt()));

        expect(result.dataOrThrow,
            [purchaseResult1, purchaseResult3, purchaseResult2]);
      });

      test('購入日昇順', () async {
        final result = await useCase(SortPurchaseResultsUseCaseParams(
            purchaseResults: purchaseResults,
            sortType: PurchaseResultSortType.oldestPurchaseDate()));

        expect(result.dataOrThrow,
            [purchaseResult1, purchaseResult3, purchaseResult2]);
      });

      test('購入日降順', () async {
        final result = await useCase(SortPurchaseResultsUseCaseParams(
            purchaseResults: purchaseResults,
            sortType: PurchaseResultSortType.newestPurchaseDate()));

        expect(result.dataOrThrow,
            [purchaseResult2, purchaseResult3, purchaseResult1]);
      });
    });
  });
}
