import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class WebProductView extends StatelessWidget {
  final ViewAbstract viewAbstract;
  const WebProductView({super.key, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              child: Flex(
                direction: constraints.maxWidth > 720
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                  Expanded(
                      flex: constraints.maxWidth > 720.0 ? 1 : 0,
                      child: WebProductImages()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
