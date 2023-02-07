import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class TitleAndDescriptopnAndImage extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? customDescription;
  final String? primaryTitle;
  final IconData? customIconData;
  final Widget? customWidget;
  const TitleAndDescriptopnAndImage(
      {super.key,
      this.primaryTitle,
      required this.title,
      this.customDescription,
      this.description,
      this.customWidget,
      this.customIconData});

  // We can use same idea as ios_app_ad.dart and swap children order, let's copy code
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth),
        tablet: _buildUi(kTabletMaxWidth),
        mobile: _buildUi(getMobileMaxWidth(context)),
      ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (primaryTitle != null)
                        Text(
                          primaryTitle!,
                          style: GoogleFonts.roboto(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.0,
                          ),
                        ),
                      if (primaryTitle != null)
                        const SizedBox(
                          height: 15.0,
                        ),
                      Text(
                        title,
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                          fontSize: 35.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      description != null
                          ? Text(
                              description!,
                              style: const TextStyle(
                                color: kCaptionColor,
                                height: 1.5,
                                fontSize: 15.0,
                              ),
                            )
                          : customDescription!,
                      const SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                Expanded(
                    flex: constraints.maxWidth > 720.0 ? 1 : 0,
                    child: customWidget != null
                        ? customWidget!
                        : Icon(
                            customIconData!,
                            size: constraints.maxWidth > 720.0 ? 100 : 350.0,
                          )),
              ],
            ),
          );
        },
      ),
    );
  }
}
