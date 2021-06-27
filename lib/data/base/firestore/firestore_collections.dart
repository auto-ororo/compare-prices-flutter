import 'package:flutter/foundation.dart';

enum FirestoreCollections {
  Versions,
  Users,
  Commodities,
  PurchaseResults,
  Shops,
}

extension FirestoreCollectionsExtention on FirestoreCollections {
  String get pathName {
    final rawString = describeEnum(this);
    final firstChar = rawString[0].toLowerCase();
    return firstChar + rawString.substring(1);
  }
}
