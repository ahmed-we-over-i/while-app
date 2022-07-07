extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension Extension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';

  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  String get removeSpacesAndLowercase => this.replaceAll(' ', '').toLowerCase();
}
