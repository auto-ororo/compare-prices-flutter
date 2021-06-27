import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/data/base/firestore/dtos/firestore_purchase_result.dart';
import 'package:compare_prices/data/base/firestore/firebase_firestore_extensions.dart';
import 'package:compare_prices/domain/entities/purchase_result.dart';
import 'package:compare_prices/domain/repositories/purchase_result_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestorePurchaseResultRepository extends PurchaseResultRepository {
  final _store = FirebaseFirestore.instance;

  @override
  Future<void> createPurchaseResult(PurchaseResult purchaseResult) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _store.purchaseResultDocRef(user.uid, purchaseResult.id).set(
        purchaseResult.convertToFirestorePurchaseResult().toJson(),
        SetOptions(merge: false));
  }

  @override
  Future<PurchaseResult?> getEnabledPurchaseResultById(String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .purchaseResultColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("id", isEqualTo: id)
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToPurchaseResults(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<void> updatePurchaseResult(PurchaseResult purchaseResult) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _store.purchaseResultDocRef(user.uid, purchaseResult.id).set(
        purchaseResult.convertToFirestorePurchaseResult().toJson(),
        SetOptions(merge: true));
  }

  List<PurchaseResult> _convertSnapshotToPurchaseResults(
      QuerySnapshot snapshot) {
    return snapshot.docs
        .map((e) =>
            FirestorePurchaseResult.fromJson(e.data() as Map<String, dynamic>)
                .convertToPurchaseResult())
        .toList();
  }

  @override
  Future<PurchaseResult?>
      getEnabledMostInexpensivePurchaseResultPerUnitByCommodityId(
          String commodityId) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .purchaseResultColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("commodityId", isEqualTo: commodityId)
        .orderBy("unitPrice")
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToPurchaseResults(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<PurchaseResult?> getEnabledNewestPurchaseResultByCommodityId(
      String commodityId) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .purchaseResultColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("commodityId", isEqualTo: commodityId)
        .orderBy("purchaseDate", descending: true)
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToPurchaseResults(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<List<PurchaseResult>> getEnabledPurchaseResultsByCommodityId(
      String commodityId) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .purchaseResultColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("commodityId", isEqualTo: commodityId)
        .get(GetOptions(source: Source.cache));

    return _convertSnapshotToPurchaseResults(snapshot);
  }
}
