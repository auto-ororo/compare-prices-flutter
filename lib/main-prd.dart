import 'package:compare_prices/ui/app.dart';
import 'package:flutter/material.dart';

import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.PRD;
  runApp(App());
}
