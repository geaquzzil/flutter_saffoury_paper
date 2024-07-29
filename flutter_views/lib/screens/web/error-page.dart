// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/screens/web/base.dart';
import 'package:flutter_view_controller/screens/web/components/title_and_image.dart';
import 'package:flutter_view_controller/screens/web/parallex/parallexes.dart';

class ErrorWebPage extends BaseWebPageSlivers {
  final String errorMessage;
  ErrorWebPage(
      {super.key,
      required this.errorMessage,
      super.buildFooter = true,
      super.buildHeader = false,
      super.useSmallFloatingBar = false});

  @override
  Widget? getCustomAppBar(BuildContext context, BoxConstraints? constraints) {
    return null;
  }
  @override
  List<Widget> getContentWidget(
      BuildContext context, BoxConstraints constraints) {
    return [
      SliverFillRemaining(
        child: Center(
          child: LocationListItem(
            usePadding: false,
            useResponsiveLayout: false,
            soildColor: Colors.black38,
            customCenterWidget: TitleAndDescriptopnAndImage(
              // primaryTitle: "Hello, There",
              title: "ERROR\n$errorMessage".toUpperCase(),
              description: "",
              customWidget: const SizedBox(),
              customIconData: Icons.error,

              // backgroundImage:
              //     "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
            ),
            // useResponsiveLayout: true,
            country: "",
            name: "",
            imageUrl:
                "http://www.saffoury.com/SaffouryPaper2/Images/24a802d340815c27a72f798234f26703.jpg",
          ),
        ),
      )
    ];
  }
}
