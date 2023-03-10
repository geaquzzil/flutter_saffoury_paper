import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/web_theme.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Html? description;
  final bool useRespnosiveLayout;
  const HeaderText(
      {super.key,
      this.fontSize = 35,
      this.useRespnosiveLayout = true,
      required this.text,
      this.description});

  @override
  Widget build(BuildContext context) {
    if (!useRespnosiveLayout) {
      return getBody(context);
    }
    return ScreenHelper(
      desktop: _buildUi(kDesktopMaxWidth),
      tablet: _buildUi(kTabletMaxWidth),
      mobile: _buildUi(getMobileMaxWidth(context)),
    );
  }

  Widget _buildUi(double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveWrapper(
            maxWidth: width,
            minWidth: width,
            defaultScale: false,
            child: Flex(
              direction:
                  constraints.maxWidth > 720 ? Axis.horizontal : Axis.vertical,
              children: [
                // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: getBody(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column getBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: getTitleTextStyle(context, fontSize: fontSize)),
        if (description != null)
          const SizedBox(
            height: 10.0,
          ),
        if (description != null) description!,
      ],
    );
  }
}
