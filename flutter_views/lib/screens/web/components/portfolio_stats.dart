import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/models/stat.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

final List<Stat> stats = [
  Stat(count: "43", text: "Clients"),
  Stat(count: "68+", text: "Projects"),
  Stat(count: "17", text: "Awards"),
  Stat(count: "10", text: "Years\nExperience"),
];

class PortfolioStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return Container(
      child: ResponsiveWrapper(
        maxWidth: width,
        minWidth: width,
        defaultScale: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint) {
            return Wrap(
              spacing: 20.0,
              runSpacing: 20.0,
              children: stats.map((stat) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  // Just use the helper here really
                  width: ScreenHelper.isMobile(context)
                      ? constraint.maxWidth / 2.0 - 20
                      : (constraint.maxWidth / 4.0 - 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat.count,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 32.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        stat.text,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: kCaptionColor,
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
