import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/screens/web/web_theme.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TitleAndDescriptopnResponsive extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? customDescription;
  final String? primaryTitle;
  final Widget? addonWidget;
  const TitleAndDescriptopnResponsive({
    super.key,
    this.primaryTitle,
    this.title,
    this.addonWidget,
    this.customDescription,
    this.description,
  });

  // We can use same idea as ios_app_ad.dart and swap children order, let's copy code
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(context, kDesktopMaxWidth),
        tablet: _buildUi(context, kTabletMaxWidth),
        mobile: _buildUi(context, getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return MaxWidthBox(
            maxWidth: width,
            // minWidth: width,
            // defaultScale: false,
            child: getUiBody(context, constraints),
          );
        },
      ),
    );
  }

  Flex getUiBody(BuildContext context, BoxConstraints constraints) {
    return Flex(
      direction: constraints.maxWidth > 720 ? Axis.horizontal : Axis.vertical,
      children: [
        // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
        Expanded(
          flex: constraints.maxWidth > 720.0 ? 1 : 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (primaryTitle != null)
                FadeInLeft(
                  key: UniqueKey(),
                  child: Text(
                    primaryTitle!,
                    style: GoogleFonts.roboto(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              if (primaryTitle != null)
                const SizedBox(
                  height: 15.0,
                ),
              if (title != null)
                FadeInLeft(
                    key: UniqueKey(),
                    child: Text(title!, style: getTitleTextStyle(context))),
              if (title != null)
                const SizedBox(
                  height: 10.0,
                ),
              description != null
                  ? FadeInLeft(
                      key: UniqueKey(),
                      child: Text(description!,
                          style: getSubtitleTextStyle(context)),
                    )
                  : FadeInLeft(key: UniqueKey(), child: customDescription!),
              const SizedBox(
                height: 25.0,
              ),
              if (addonWidget != null) addonWidget!,
            ],
          ),
        )
      ],
    );
  }
}
