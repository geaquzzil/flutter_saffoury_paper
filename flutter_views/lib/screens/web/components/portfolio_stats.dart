import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/models/stat.dart';
import 'package:flutter_view_controller/screens/web/web_theme.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_framework.dart';

final List<Stat> stats = [
  Stat(count: "100+", text: "Clients"),
  Stat(count: "68+", text: "Products"),
  Stat(count: "10+", text: "Awards"),
  Stat(count: "30+", text: "Years\nExperience"),
];

class PortfolioStats extends StatelessWidget {
  const PortfolioStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ScreenHelper(
        largeTablet: _buildUi(kDesktopMaxWidth, context),
        smallTablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return MaxWidthBox(
      maxWidth: width,
      // minWidth: width,
      // defaultScale: false,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
          return Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: stats.map((stat) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                // Just use the helper here really
                width: isMobile(context)
                    ? constraint.maxWidth / 2.0 - 20
                    : (constraint.maxWidth / 4.0 - 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(stat.count, style: getTitleTextStyle(context)),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(stat.text, style: getSubtitleTextStyle(context))
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
