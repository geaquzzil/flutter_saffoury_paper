import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/screens/web/web_theme.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TitleAndDescriptopnAndImageLeft extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? customDescription;
  final String? primaryTitle;
  final String? backgroundImage;
  final IconData? customIconData;
  final bool? isBackgroundImageBlurred;
  final bool descriptionIsWhite;
  final Widget? customWidget;
  final List<Widget>? actions;
  const TitleAndDescriptopnAndImageLeft(
      {super.key,
      this.primaryTitle,
      required this.title,
      this.customDescription,
      this.description,
      this.descriptionIsWhite = false,
      this.actions,
      this.isBackgroundImageBlurred = true,
      this.backgroundImage,
      this.customWidget,
      this.customIconData});

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
          return MaxWidthBox(
            maxWidth: width,
            // minWidth: width,
            // defaultScale: false,
            child: Container(
              child: Flex(
                direction: constraints.maxWidth > 720
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  // Disable expanded on smaller screen to avoid Render errors by setting flex to 0
                  Expanded(
                      flex: constraints.maxWidth > 720.0 ? 1 : 0,
                      child: customWidget != null
                          ? FadeInRight(key: UniqueKey(), child: customWidget!)
                          : FadeInRight(
                              key: UniqueKey(),
                              child: Icon(
                                customIconData!,
                                size:
                                    constraints.maxWidth > 720.0 ? 100 : 350.0,
                              ),
                            )),

                  Expanded(
                    flex: constraints.maxWidth > 720.0 ? 1 : 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (primaryTitle != null)
                          FadeInRight(
                            key: UniqueKey(),
                            child: Text(primaryTitle!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: kPrimaryColor)),
                          ),
                        if (primaryTitle != null)
                          const SizedBox(
                            height: 15.0,
                          ),
                        FadeInRight(
                          key: UniqueKey(),
                          child: Text(title, style: getTitleTextStyle(context)),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        description != null
                            ? FadeInRight(
                                key: UniqueKey(),
                                child: Text(description!,
                                    style: getSubtitleTextStyle(context)),
                              )
                            : FadeInRight(
                                key: UniqueKey(), child: customDescription!),
                        const SizedBox(
                          height: 25.0,
                        ),
                        getButtons()
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getButtons() {
    return Row(
      children: [
        if (actions != null) ...actions!
        // MouseRegion(
        //   cursor: SystemMouseCursors.click,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: kPrimaryColor,
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     height: 48.0,
        //     padding: const EdgeInsets.symmetric(
        //       horizontal: 28.0,
        //     ),
        //     child: TextButton(
        //       onPressed: () {},
        //       child: const Center(
        //         child: Text(
        //           "EXPLORE MORE",
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 13.0,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   width: 10.0,
        // ),
        // MouseRegion(
        //   cursor: SystemMouseCursors.click,
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8.0),
        //       border: Border.all(
        //         color: kPrimaryColor,
        //       ),
        //     ),
        //     height: 48.0,
        //     padding: const EdgeInsets.symmetric(horizontal: 28.0),
        //     child: TextButton(
        //       onPressed: () {},
        //       child: const Center(
        //         child: Text(
        //           "NEXT APP",
        //           style: TextStyle(
        //             color: kPrimaryColor,
        //             fontSize: 13.0,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
