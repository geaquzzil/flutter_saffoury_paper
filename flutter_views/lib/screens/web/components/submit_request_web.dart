import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SubmitRequestWeb extends StatelessWidget {
  final String text;
  final double fontSize;
  final Html description;
  const SubmitRequestWeb(
      {super.key,
      this.fontSize = 35,
      required this.text,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      largeTablet: _buildUi(kDesktopMaxWidth),
      smallTablet: _buildUi(kTabletMaxWidth),
      mobile: _buildUi(getMobileMaxWidth(context)),
    );
  }

  Widget _buildUi(double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MaxWidthBox(
            maxWidth: width,
            // minWidth: width,
            // defaultScale: false,
            child: Flex(
              direction: constraints.maxWidth > 720
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                          fontSize: fontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      description,
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
