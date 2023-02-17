import 'package:cached_network_image/cached_network_image.dart';
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

class GridViewApi extends StatelessWidget {
  final ViewAbstract viewAbstract;
  final String? title;
  final String? description;
  double? customHeight;
  ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> valuePageNotifier = ValueNotifier<int>(0);
  GridViewApi(
      {Key? key,
      this.customHeight,
      required this.viewAbstract,
      this.title,
      this.description})
      : super(key: key);

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
    return ResponsiveWrapper(
      maxWidth: width,
      minWidth: width,
      defaultScale: false,
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
                  future: viewAbstract.listCall(
                      count: ScreenHelper.isDesktop(context) ? 10 : 4,
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
                            : 250,
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

class WebGridViewItem extends StatelessWidget {
  final ViewAbstract item;
  late WebCategoryGridableInterface _categoryGridable;

  WebGridViewItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    _categoryGridable = item as WebCategoryGridableInterface;
    // return item.getImageUrl(context) == null
    //     ? Container()
    //     : HoverImage(
    //         image: item.getImageUrl(context)!,
    //       );
    return HoverImage(
      image: item.getImageUrl(context) ?? "",
      // scale: false,
      builder: (isHovered) => GestureDetector(
        onTap: () {
          context.goNamed(indexWebView,
              params: {
                "id": item.iD.toString(),
                "tableName": item.getTableNameApi()!
              },
              extra: item);
        },
        child: Stack(
          children: [
            _buildBackground(context),
            // _buildBackground(context),
            if (isHovered) _buildGradient(),
            if (isHovered) _buildTitleAndSubtitle(context),

            // _buildCenterWidget(context)
          ],
        ),
      ),
    );
  }

  Widget _buildHoverBackground(BuildContext context) {
    return Positioned.fill(
        child: item.getImageUrl(context) == null
            ? Container()
            : HoverImage(
                image: item.getImageUrl(context)!,
              ));
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned.fill(
      child: Container(
          // width: 150,
          // height: 100,
          decoration: BoxDecoration(
              image: item.getImageUrl(context) == null
                  ? null
                  : DecorationImage(
                      image: CachedNetworkImageProvider(
                          item.getImageUrl(context)!),
                      fit: BoxFit.cover),
              color: null,
              borderRadius: const BorderRadius.all(Radius.circular(18)))),
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.7)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.getMainHeaderTextOnly(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.getMainHeaderLabelTextOnly(context),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
