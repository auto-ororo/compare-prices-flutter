import 'package:flutter/material.dart';

import 'flavors.dart';
import 'ui/app.dart';

void main() {
  F.appFlavor = Flavor.DEV;
  runApp(App());
}