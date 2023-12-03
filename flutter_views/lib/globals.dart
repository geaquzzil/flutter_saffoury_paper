import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class Globals {
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == "ar";
  }

  static Future<Uint8List> svgStringToPngBytes(
  // The SVG string
  String svgStringContent,
  // The target width of the output image
  double targetWidth,
  // The target height of the output image
  double targetHeight,
) async {
  final SvgStringLoader svgStringLoader = SvgStringLoader(svgStringContent);
  final PictureInfo pictureInfo = await vg.loadPicture(svgStringLoader, null);
  final ui.Picture picture = pictureInfo.picture;
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(targetWidth, targetHeight)));
  canvas.scale(targetWidth / pictureInfo.size.width, targetHeight / pictureInfo.size.height);
  canvas.drawPicture(picture);
  final ui.Image imgByteData = await recorder.endRecording().toImage(targetWidth.ceil(), targetHeight.ceil());
  final ByteData? bytesData = await imgByteData.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List imageData = bytesData?.buffer.asUint8List() ?? Uint8List(0);
  pictureInfo.picture.dispose();
  return imageData;
}
}
