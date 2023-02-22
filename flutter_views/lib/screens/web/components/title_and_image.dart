import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final String? backgroundImage;
  final IconData? customIconData;
  final bool? isBackgroundImageBlurred;
  final Widget? customWidget;
  const TitleAndDescriptopnAndImage(
      {super.key,
      this.primaryTitle,
      required this.title,
      this.customDescription,
      this.description,
      this.isBackgroundImageBlurred = true,
      this.backgroundImage,
      this.customWidget,
      this.customIconData});

  // We can use same idea as ios_app_ad.dart and swap children order, let's copy code
  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      desktop: _buildUi(context, kDesktopMaxWidth),
      tablet: _buildUi(context, kTabletMaxWidth),
      mobile: _buildUi(context, getMobileMaxWidth(context)),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ResponsiveWrapper(
            maxWidth: width,
            minWidth: width,
            defaultScale: false,
            child: backgroundImage != null
                ? getUiBodyWithBackgroundImage(constraints, context)
                : getUiBody(constraints),
          );
        },
      ),
    );
  }

  Widget getUiBodyWithBackgroundImage(
      BoxConstraints constraints, BuildContext context) {
    double carouselContainerHeight = MediaQuery.of(context).size.height *
        (SizeConfig.isMobile(context) ? .25 : .5);
    Widget image = CachedNetworkImage(
      color: Theme.of(context).colorScheme.onBackground,
      imageUrl: backgroundImage!,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: Container(
            height: carouselContainerHeight,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            child: getUiBody(constraints),
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    return image;
  }

  Flex getUiBody(BoxConstraints constraints) {
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
              FadeInLeft(
                key: UniqueKey(),
                child: Text(
                  title,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                    fontSize: 35.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              description != null
                  ? FadeInLeft(
                      key: UniqueKey(),
                      child: Text(
                        description!,
                        style: const TextStyle(
                          color: kCaptionColor,
                          height: 1.5,
                          fontSize: 15.0,
                        ),
                      ),
                    )
                  : FadeInLeft(key: UniqueKey(), child: customDescription!),
              const SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 25.0,
        ),
        // if (constraints.maxWidth > 720.0)
        Expanded(
            flex: constraints.maxWidth > 720.0 ? 1 : 0,
            child: customWidget != null
                ? FadeInRight(key: UniqueKey(), child: customWidget!)
                : FadeInRight(
                    key: UniqueKey(),
                    child: Icon(
                      customIconData!,
                      size: 100,
                    ),
                  )),
        if (constraints.maxWidth < 720.0)
          const SizedBox(
            height: 25.0,
          ),
      ],
    );
  }
}
