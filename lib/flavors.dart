enum Flavor {
  DEV,
  PRD,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Compare Prices Dev';
      case Flavor.PRD:
        return 'Compare Prices';
      default:
        return 'title';
    }
  }

}
