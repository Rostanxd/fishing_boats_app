class ConversionDataType {
  /// This function check if the number is a double with decimals, if it is,
  /// it will return a string using decimal comma ".", otherwise it'll look
  /// like a integer.
  static String doubleQuantityToString(double number) {
    double result = number.remainder(1.0);
    if (result != 0) return number.toString();
    return number.toInt().toString();
  }
}