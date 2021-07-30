enum Flavor {
  DEV,
  PRD,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Dev Compey';
      case Flavor.PRD:
        return 'Compey';
      default:
        return 'title';
    }
  }

}
