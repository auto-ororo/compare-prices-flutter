import 'package:compare_prices/domain/models/commodity.dart';
import 'package:compare_prices/domain/models/purchase_result.dart';
import 'package:compare_prices/domain/models/quantity_type.dart';
import 'package:compare_prices/domain/models/shop.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PurchaseResult', () {
    group('unitPrice', () {
      test('整数で割り切れる場合、計算結果が正しいこと', () {
        final purchaseResult = _createTestData(120, 10);
        expect(purchaseResult.unitPrice(), 12);
      });

      test('整数で割り切れない場合、小数点第1位までの数値が四捨五入された上で返却されること', () {
        final purchaseResult = _createTestData(10, 3);
        expect(purchaseResult.unitPrice(), 3.3);

        final purchaseResult2 = _createTestData(10, 6);
        expect(purchaseResult2.unitPrice(), 1.7);
      });
    });
  });
}

PurchaseResult _createTestData(int price, int quantity) {
  return PurchaseResult.create(
      commodity: Commodity.create("commodity", QuantityType.count()),
      shop: Shop.createByName("shop"),
      price: price,
      quantity: quantity,
      purchaseDate: DateTime.now());
}
