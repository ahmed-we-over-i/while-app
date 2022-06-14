extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
}
