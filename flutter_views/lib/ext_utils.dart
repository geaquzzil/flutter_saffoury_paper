import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      value.toRadixString(16).substring(2, 8);
}

String dateFormatString = "yyyy-MM-dd HH:mm:ss";

extension DatesString on String? {
  /// get Date time format from string
  /// if null return the now date
  DateTime toDateTime() {
    if (this == null) return DateTime.now();
    DateFormat dateFormat = DateFormat(dateFormatString);
    return dateFormat.parse(this ?? "");
  }

  String toDateTimeNowString() {
    DateFormat dateFormat = DateFormat(dateFormatString);
    return dateFormat.format(DateTime.now());
  }
}

extension DatesDateTime on DateTime? {
  String toDateTimeString() {
    if (this == null) return "".toDateTimeNowString();
    DateFormat dateFormat = DateFormat(dateFormatString);
    return dateFormat.format(this ?? DateTime.now());
  }
}

extension IterableModifier<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) =>
      cast<E?>().firstWhere((v) => v != null && test(v), orElse: () => null);
}

extension NonNullableDouble on double? {
  double toNonNullable() {
    return this ?? 0;
  }
}
