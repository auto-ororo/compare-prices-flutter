import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';

class SamplePurchaseResultRepository extends PurchaseResultRepository {
  final _sampleData = _SampleData();

  @override
  Future<void> addPurchaseResult(PurchaseResult purchaseResult) async {
    _sampleData.purchaseResults.add(purchaseResult);
  }

  @override
  Future<void> deletePurchaseResult(PurchaseResult purchaseResult) async {
    final index = _sampleData.purchaseResults
        .indexWhere((element) => element.id == purchaseResult.id);
    final target = _sampleData.purchaseResults[index];
    _sampleData.purchaseResults[index] = target.copyWith(isEnabled: false);
  }

  @override
  Future<PurchaseResult?> getEnabledMostInexpensivePurchaseResultByCommodityId(
      String commodityId) async {
    final purchaseResults = _sampleData.purchaseResults.where((element) =>
        (element.commodityId == commodityId) && (element.isEnabled));

    if (purchaseResults.length == 0) return null;

    return purchaseResults.reduce((current, next) {
      if (current.price >= next.price) {
        return next;
      } else {
        return current;
      }
    });
  }

  @override
  Future<PurchaseResult?> getEnabledNewestPurchaseResultByCommodityId(
      String commodityId) async {
    final purchaseResults = _sampleData.purchaseResults.where((element) =>
        (element.commodityId == commodityId) && (element.isEnabled));

    if (purchaseResults.length == 0) return null;

    return purchaseResults.reduce((current, next) {
      if (current.purchaseDate.compareTo(next.purchaseDate) == -1) {
        return next;
      } else {
        return current;
      }
    });
  }

  @override
  Future<PurchaseResult?> getEnabledPurchaseResultById(String id) async {
    return _sampleData.purchaseResults.firstWhere(
        (element) => (element.id == id) && element.isEnabled,
        orElse: null);
  }

  @override
  Future<List<PurchaseResult>> getEnabledPurchaseResultsByCommodityId(
      String commodityId) async {
    return _sampleData.purchaseResults
        .where((element) =>
            (element.commodityId == commodityId) && element.isEnabled)
        .toList();
  }

  @override
  Future<void> updatePurchaseResult(PurchaseResult purchaseResult) async {
    final index = _sampleData.purchaseResults
        .indexWhere((element) => element.id == purchaseResult.id);
    _sampleData.purchaseResults[index] = purchaseResult;
  }
}

class _SampleData {
  static _SampleData? _instance;

  List<PurchaseResult> purchaseResults = [
    PurchaseResult(
      id: "p1",
      commodityId: 'c1',
      shopId: 's1',
      price: 150,
      purchaseDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    PurchaseResult(
      id: "p2",
      commodityId: 'c1',
      shopId: 's2',
      price: 100,
      purchaseDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    PurchaseResult(
      id: "p3",
      commodityId: 'c2',
      shopId: 's5',
      price: 180,
      purchaseDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  factory _SampleData() {
    if (_instance == null) {
      _instance = new _SampleData._();
    }

    return _instance!;
  }

  _SampleData._();
}
