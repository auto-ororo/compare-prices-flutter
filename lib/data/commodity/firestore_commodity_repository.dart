import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/data/base/firestore/dtos/firestore_commodity.dart';
import 'package:compare_prices/data/base/firestore/firebase_firestore_extensions.dart';
import 'package:compare_prices/domain/entities/commodity.dart';
import 'package:compare_prices/domain/repositories/commodity_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreCommodityRepository extends CommodityRepository {
  final _store = FirebaseFirestore.instance;

  @override
  Future<void> createCommodity(Commodity commodity) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _store.commodityDocRef(user.uid, commodity.id).set(
        commodity.convertToFirestoreCommodity().toJson(),
        SetOptions(merge: false));
  }

  @override
  Future<List<Commodity>> getAllCommodities() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .commodityColRef(user.uid)
        .get(GetOptions(source: Source.cache));

    return _convertSnapshotToCommodities(snapshot);
  }

  @override
  Future<Commodity?> getEnabledCommodityById(String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .commodityColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("id", isEqualTo: id)
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToCommodities(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<Commodity?> getEnabledCommodityByName(String name) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .commodityColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("name", isEqualTo: name)
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToCommodities(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<List<Commodity>> getEnabledCommodities() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .commodityColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .get(GetOptions(source: Source.cache));

    return _convertSnapshotToCommodities(snapshot);
  }

  @override
  Future<void> updateCommodity(Commodity commodity) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _store.commodityDocRef(user.uid, commodity.id).set(
        commodity.convertToFirestoreCommodity().toJson(),
        SetOptions(merge: true));
  }

  List<Commodity> _convertSnapshotToCommodities(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((e) =>
            FirestoreCommodity.fromJson(e.data() as Map<String, dynamic>)
                .convertToCommodity())
        .toList();
  }
}
