import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:provider/provider.dart';

class CompanyLogo extends StatelessWidget {
  double? size;
  CompanyLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final svg = context.watch<SVGData>();
    // debugPrint("CompanyLogo=> $svg.code");
    return svg.code.isNotEmpty
        ? size != null
            ? SizedBox(
                width: size,
                height: size,
                child: Center(
                    child: SvgPicture.string(
                  svg.code,
                  height: size,
                  width: size,
                )),
              )
            : Center(
                child: SvgPicture.string(
                svg.code,
                height: size,
                width: size,
              ))
        : const Center(child: CircularProgressIndicator.adaptive());
  }

  static void updateLogoColor(BuildContext context, Color? newColor) {
    final svg = context.read<SVGData>();

    final previousColor = context.read<PreviousColor>();
    if (newColor == null) return;
    String hexColor = newColor.colorToHexString();
    svg.updateCode(previousColor.value, hexColor);
    previousColor.updateValue(hexColor);
  }
}

class PreviousColor with ChangeNotifier {
  /// Holds the Hex Color Value.
  String value = '';

  PreviousColor(this.value);

  void updateValue(String newValue) {
    value = newValue;
    notifyListeners();
  }

  @override
  String toString() => 'PreviousColor(value:$value)';
}

class SVGData with ChangeNotifier {
  /// Holds the `SVG` Formatted Code.
  String code = '';

  SVGData(this.code);

  void updateCode(String previousColor, String newColor) {
    code = code.replaceAll(previousColor, newColor);
    notifyListeners();
  }

  @override
  String toString() => 'SVGData(code:$code)';
}
