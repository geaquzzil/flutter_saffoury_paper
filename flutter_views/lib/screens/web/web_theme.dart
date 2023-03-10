import 'package:flutter/material.dart';

//  GoogleFonts.roboto(
//   color: Colors.white,
//   fontWeight: FontWeight.w900,
//   height: 1.3,
//   fontSize: 35.0,
// ),
TextStyle? getTitleTextStyle(BuildContext context,{double fontSize=35}) {
  return Theme.of(context)
      .textTheme
      .titleLarge
      ?.copyWith(fontSize: fontSize, height: 1.3, fontWeight: FontWeight.w900);
}

TextStyle? getSubtitleTextStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .bodyMedium
      ?.copyWith(fontSize: 15, height: 1.5,);
}
TextStyle? getBodyTextStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .bodyMedium
      ?.copyWith(fontSize: 15, height: 1.5,);
}
