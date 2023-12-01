
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/models/design_process.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../components/grid_view_api_category.dart';

class WebProductList extends StatelessWidget {
  final ViewAbstract viewAbstract;
  final String? title;
  final String? description;
  final String? searchQuery;
  double? customHeight;
  ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> valuePageNotifier = ValueNotifier<int>(0);
  WebProductList(
      {super.key,
      this.customHeight,
      this.searchQuery,
      required this.viewAbstract,
      this.title,
      this.description});

  @override
  Widget build(BuildContext context) {
    customHeight = customHeight ??
        MediaQuery.of(context).size.height *
            (SizeConfig.isMobile(context) ? .6 : .75);
    return OnHoverWidget(
      mouseCursor: SystemMouseCursors.basic,
      onHover: valueNotifier,
      builder: (isHover) {
        return SizedBox(
          width: double.infinity,
          height: customHeight,
          child: Stack(children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ScreenHelper(
                    desktop: _buildUi(context, kDesktopMaxWidth),
                    tablet: _buildUi(context, kTabletMaxWidth),
                    mobile: _buildUi(context, getMobileMaxWidth(context)),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                return Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: double.infinity,
                        child: value == false
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          if (valuePageNotifier.value == 0) {
                                            return;
                                          }
                                          valuePageNotifier.value =
                                              valuePageNotifier.value - 1;
                                        },
                                        icon: const Icon(
                                            size: 100,
                                            Icons.arrow_back_ios_new_sharp)),
                                    IconButton(
                                        onPressed: () {
                                          valuePageNotifier.value =
                                              valuePageNotifier.value + 1;
                                        },
                                        icon: const Icon(
                                            size: 100,
                                            Icons.arrow_forward_ios_sharp)),
                                  ],
                                ),
                              )),
                  ),
                );
              },
            ),
          ]),
        );
      },
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    debugPrint("GridViewApi is building");
    // we need the context to get maxWidth before the constraints below
    return MaxWidthBox(
      maxWidth: width,
      // minWidth: width,
      // defaultScale: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (title != null)
            Align(
              alignment: Alignment.topCenter,
              child: getWebText(title: title!),
            ),
          if (description != null)
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                description!,
                style: const TextStyle(
                  color: kCaptionColor,
                  height: 1.5,
                  fontSize: 15.0,
                ),
              ),
            ),
          const SizedBox(
            height: 50.0,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return ValueListenableBuilder<int>(
                valueListenable: valuePageNotifier,
                builder: (context, value, child) =>
                    FutureBuilder<List<dynamic>?>(
                  future: searchQuery != null
                      ? viewAbstract.search(20, value, searchQuery!)
                      : viewAbstract.listCall(
                          count: ScreenHelper.isDesktop(context) ? 20 : 4,
                          page: value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    List<ViewAbstract>? list = snapshot.data?.cast();
                    if (list == null) {
                      return Container();
                    }

                    return ResponsiveGridView.builder(
                      padding: const EdgeInsets.all(0.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      alignment: Alignment.topCenter,
                      gridDelegate: ResponsiveGridDelegate(
                        mainAxisSpacing:
                            ScreenHelper.isDesktop(context) ? 40.0 : 20.0,
                        crossAxisSpacing: 40.0,
                        maxCrossAxisExtent: ScreenHelper.isTablet(context) ||
                                ScreenHelper.isMobile(context)
                            ? constraints.maxWidth / 2
                            : constraints.maxWidth / 5,
                        // Hack to adjust child height
                        childAspectRatio: ScreenHelper.isDesktop(context)
                            ? 1
                            : MediaQuery.of(context).size.aspectRatio * 1.5,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        var designProcesse = list[index];
                        return WebGridViewItem(
                          item: designProcesse,
                        );
                      },
                      itemCount: list.length,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
