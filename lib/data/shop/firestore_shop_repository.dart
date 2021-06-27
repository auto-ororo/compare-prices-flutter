import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/data/base/firestore/dtos/firestore_shop.dart';
import 'package:compare_prices/data/base/firestore/firebase_firestore_extensions.dart';
import 'package:compare_prices/domain/entities/shop.dart';
import 'package:compare_prices/domain/repositories/shop_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreShopRepository extends ShopRepository {
  final _store = FirebaseFirestore.instance;

  @override
  Future<void> createShop(Shop shop) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _store
        .shopDocRef(user.uid, shop.id)
        .set(shop.convertToFirestoreShop().toJson(), SetOptions(merge: false));
  }

  @override
  Future<List<Shop>> getAllShops() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot =
        await _store.shopColRef(user.uid).get(GetOptions(source: Source.cache));

    return _convertSnapshotToShops(snapshot);
  }

  @override
  Future<Shop?> getEnabledShopById(String id) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .shopColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("id", isEqualTo: id)
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToShops(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<Shop?> getEnabledShopByName(String name) async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .shopColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .where("name", isEqualTo: name)
        .get(GetOptions(source: Source.cache));

    final list = _convertSnapshotToShops(snapshot);
    return list.isNotEmpty ? list.first : null;
  }

  @override
  Future<List<Shop>> getEnabledShops() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshot = await _store
        .shopColRef(user.uid)
        .where("isEnabled", isEqualTo: true)
        .get(GetOptions(source: Source.cache));

    return _convertSnapshotToShops(snapshot);
  }

  @override
  Future<void> updateShop(Shop shop) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _store
        .shopDocRef(user.uid, shop.id)
        .set(shop.convertToFirestoreShop().toJson(), SetOptions(merge: true));
  }

  List<Shop> _convertSnapshotToShops(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((e) => FirestoreShop.fromJson(e.data() as Map<String, dynamic>)
            .convertToShop())
        .toList();
  }
}
