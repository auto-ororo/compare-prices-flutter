import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compare_prices/data/base/firestore/firestore_collections.dart';

const _versionCode = "v1";

extension FirebaseFirestoreExtensions on FirebaseFirestore {
  DocumentReference versionDocRef() =>
      this.collection(FirestoreCollections.Versions.pathName).doc(_versionCode);

  DocumentReference userDocRef(String userId) => this
      .versionDocRef()
      .collection(FirestoreCollections.Users.pathName)
      .doc(userId);

  CollectionReference commodityColRef(String userId) => this
      .userDocRef(userId)
      .collection(FirestoreCollections.Commodities.pathName);

  DocumentReference commodityDocRef(String userId, String commodityId) =>
      this.commodityColRef(userId).doc(commodityId);

  CollectionReference shopColRef(String userId) =>
      this.userDocRef(userId).collection(FirestoreCollections.Shops.pathName);

  DocumentReference shopDocRef(String userId, String shopId) =>
      this.shopColRef(userId).doc(shopId);

  CollectionReference purchaseResultColRef(String userId) => this
      .userDocRef(userId)
      .collection(FirestoreCollections.PurchaseResults.pathName);

  DocumentReference purchaseResultDocRef(
          String userId, String purchaseResultId) =>
      this.purchaseResultColRef(userId).doc(purchaseResultId);
}
