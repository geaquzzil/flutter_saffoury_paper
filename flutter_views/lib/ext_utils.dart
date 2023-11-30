import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/new_screens/dashboard/main_dashboard2.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'models/view_abstract.dart';

String dateFormatString = "yyyy-MM-dd HH:mm:ss";
String dateOnlyFormatString = "yyyy-MM-dd";

extension HexColor on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String colorToHexString() => '#${this.value.toRadixString(16).substring(2)}';

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      value.toRadixString(16).substring(2, 8);

  String _generateAlpha({required int alpha, required bool withAlpha}) {
    if (withAlpha) {
      return alpha.toRadixString(16).padLeft(2, '0');
    } else {
      return '';
    }
  }

  String toHex2({bool leadingHashSign = false, bool withAlpha = false}) =>
      '${leadingHashSign ? '#' : ''}'
              '${_generateAlpha(alpha: alpha, withAlpha: withAlpha)}'
              '${red.toRadixString(16).padLeft(2, '0')}'
              '${green.toRadixString(16).padLeft(2, '0')}'
              '${blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}

extension StringsUtils2 on String {
  Color? fromHex() {
    try {
      final buffer = StringBuffer();
      if (length == 6 || length == 7) buffer.write('ff');
      buffer.write(replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return null;
    }
  }
}

extension StringsUtils on String? {
  Color? fromHex() {
    if (this == null) return null;
    if (this!.isEmpty) return null;
    final buffer = StringBuffer();
    if (this!.length == 6 || this!.length == 7) buffer.write('ff');
    buffer.write(this!.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// get Date time format from string
  /// if null return the now date
  DateTime toDateTime() {
    if (this == null) return DateTime.now();
    if (this!.isEmpty) return DateTime.now();
    DateFormat dateFormat = DateFormat(dateFormatString, 'en-US');
    return dateFormat.parse(this ?? "");
  }

  DateTime toDateTimeOnlyDate() {
    if (this == null) return DateTime.now();
    DateFormat dateFormat = DateFormat(dateOnlyFormatString, 'en-US');
    return dateFormat.parse(this ?? "");
  }

  String toDateTimeOnlyDateString() {
    DateFormat dateFormat = DateFormat(dateOnlyFormatString, 'en-US');
    return dateFormat.format(toDateTime());
  }

  String toDateTimeNowString() {
    DateFormat dateFormat = DateFormat(dateFormatString, 'en-US');
    return dateFormat.format(toDateTime());
  }

  String toDateString() {
    DateFormat dateFormat = DateFormat(dateOnlyFormatString, 'en-US');
    return dateFormat.format(toDateTime());
  }

  String toDateTimeFirstDateYearString() {
    DateTime d = DateTime(DateTime.now().year, 1, 1);
    return d.toDateTimeString();
  }

  String toNonNullable() {
    return this ?? "";
  }
}

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  Color get getDarkingColorForFroeground {
    return isDarkMode == false
        ? Colors.transparent
        : Theme.of(this).scaffoldBackgroundColor.lighten().withOpacity(.8);
  }
}

extension DatesDateTime on DateTime? {
  String toDateTimeString() {
    if (this == null) return "".toDateTimeNowString();
    DateFormat dateFormat = DateFormat(dateFormatString, 'en');
    return dateFormat.format(this ?? DateTime.now());
  }

  String toDateTimeStringOnlyDate() {
    if (this == null) return "".toDateTimeNowString();
    DateFormat dateFormat = DateFormat(dateOnlyFormatString, 'en');
    return dateFormat.format(this ?? DateTime.now());
  }

  int daysIn() {
    if (this == null) return -1;
    int month = this!.month;
    int forYear = this!.year;
    DateTime firstOfNextMonth;
    if (month == 12) {
      firstOfNextMonth =
          DateTime(forYear + 1, 1, 1, 12); //year, month, day, hour
    } else {
      firstOfNextMonth = DateTime(forYear, month + 1, 1, 12);
    }
    int numberOfDaysInMonth =
        firstOfNextMonth.subtract(const Duration(days: 1)).day;
    //.subtract(Duration) returns a DateTime, .day gets the integer for the day of that DateTime
    return numberOfDaysInMonth;
  }
}

extension IterableModifierNullbale<E> on Iterable<E?>? {
  E? firstWhereOrNull(bool Function(E) test) {
    if (this == null) return null;
    return this!.firstWhereOrNull(test);
  }

  void setParent(ViewAbstract parent) {
    if (this == null) return;
    this!.setParent(parent);
  }
}

extension IterableModifier<E> on Iterable<E?> {
  E? firstWhereOrNull(bool Function(E) test) =>
      cast<E?>().firstWhere((v) => v != null && test(v), orElse: () => null);
  void setParent(ViewAbstract parent) {
    forEach((element) {
      (element as ViewAbstract).setParent(parent);
    });
  }
}

extension ConvertersNumbers on dynamic {}

extension NonNullableNum on num? {
  String toCurrencyFormatWithoutDecimalReturnSpaceIfZero() {
    if (this == null) return "";
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return this!.toString().replaceAll(regex, '');
  }

  String toCurrencyFormatWithoutDecimal() {
    if (this == null) return "0";
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return this!.toString().replaceAll(regex, '');
  }
}

extension NonNullableDouble on double? {
  double roundDouble() {
    if (this == null) return 0;
    return double.tryParse(this!.toStringAsFixed(2)) ?? 0;
  }

  String toCurrencyFormatWithoutDecimal() {
    if (this == null) return "0";
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return this!.toString().replaceAll(regex, '');
  }

  String toCurrencyFormatWithoutDecimalReturnSpaceIfZero() {
    if (this == null) return "";
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return this!.toString().replaceAll(regex, '');
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  double toNonNullable() {
    return this ?? 0;
  }

  String toCurrencyFormat({String symbol = ""}) {
    return NumberFormat.currency(locale: "en", symbol: " $symbol ")
        .format(toNonNullable())
        .replaceFirst(RegExp(r'\.?0*$'), '');
  }

  String toCurrencyFormatFromSetting(BuildContext context) {
    return context
        .read<AuthProvider<AuthUser>>()
        .getPriceFromSetting(context, toNonNullable());
  }
}

extension NonNullableInt on int? {
  int toNonNullable() {
    return this ?? 0;
  }

  String toCurrencyFormatChangeToDashIfZero({String symbol = ""}) {
    if (this == 0) return "-";
    return toCurrencyFormat(symbol: symbol);
  }

  String toCurrencyFormat({String symbol = ""}) {
    return NumberFormat.currency(locale: "en_US", symbol: symbol)
        .format(toNonNullable())
        .replaceFirst(RegExp(r'\.?0*$'), '');
    ;
  }
}

extension TaskTypeExtension on TaskType {
  Color getColor() {
    switch (this) {
      case TaskType.done:
        return Colors.lightBlue;
      case TaskType.inProgress:
        return Colors.amber[700]!;
      default:
        return Colors.redAccent;
    }
  }

  String toStringValue() {
    switch (this) {
      case TaskType.done:
        return "Done";
      case TaskType.inProgress:
        return "In Progress";
      default:
        return "Todo";
    }
  }
}
