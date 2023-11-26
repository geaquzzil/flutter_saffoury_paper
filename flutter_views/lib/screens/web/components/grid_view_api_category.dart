import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/interfaces/cartable_interface.dart';
import 'package:flutter_view_controller/interfaces/web/category_gridable_interface.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/components/list_web_api_master.dart';
import 'package:flutter_view_controller/screens/web/ext.dart';
import 'package:flutter_view_controller/screens/web/models/design_process.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class GridViewApi extends StatelessWidget {
  final ViewAbstract viewAbstract;
  double? customHeight;
  ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> valuePageNotifier = ValueNotifier<int>(0);
  GridViewApi({
    Key? key,
    this.customHeight,
    required this.viewAbstract,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    customHeight = customHeight ??
        MediaQuery.of(context).size.height *
            (SizeConfig.isMobile(context) ? .5 : .65);
    return OnHoverWidget(
      mouseCursor: SystemMouseCursors.basic,
      onHover: valueNotifier,
      builder: (isHover) {
        return ResponsiveWebBuilder(
          builder: (context, width) {
            return SizedBox(
              height: customHeight,
              child: Stack(
                  clipBehavior: Clip.none,
                  children: [_buildUi(context, width), getButtons()]),
            );
          },
        );
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
            getButtons(),
          ]),
        );
      },
    );
  }

  ValueListenableBuilder<bool> getButtons() {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 275),
              opacity: value ? 1 : 0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 275),
                scale: value ? 1 : 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundedIconButton(
                      icon: Icons.arrow_back_ios_new_sharp,
                      onTap: () {
                        if (valuePageNotifier.value == 0) {
                          return;
                        }
                        valuePageNotifier.value = valuePageNotifier.value - 1;
                      },
                    ),
                    RoundedIconButton(
                        onTap: () {
                          valuePageNotifier.value = valuePageNotifier.value + 1;
                        },
                        icon: Icons.arrow_forward_ios_sharp),
                  ],
                ),
              ),
            ),

            //  value == false
            //     ? Container()
            //     : Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           RoundedIconButton(
            //             icon: Icons.arrow_back_ios_new_sharp,
            //             onTap: () {
            //               if (valuePageNotifier.value == 0) {
            //                 return;
            //               }
            //               valuePageNotifier.value = valuePageNotifier.value - 1;
            //             },
            //           ),
            //           RoundedIconButton(
            //               onTap: () {
            //                 valuePageNotifier.value =
            //                     valuePageNotifier.value + 1;
            //               },
            //               icon: Icons.arrow_forward_ios_sharp),
            //         ],
            //       ),
          ),
        );
      },
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    debugPrint("GridViewApi is building");
    // we need the context to get maxWidth before the constraints below
    return ValueListenableBuilder<int>(
      valueListenable: valuePageNotifier,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.center,
          child: ListWebApiMaster(
            valueNotifierGrid: ValueNotifier<bool>(true),
            viewAbstract: viewAbstract,
            customCount: ScreenHelper.isDesktop(context)
                ? 10
                : ScreenHelper.isTablet(context)
                    ? 4
                    : 4,
            customPage: value,
            onLoad: (context, list, count, isLoading) {
              // return ResponsiveGridList(
              //     listViewBuilderOptions: ListViewBuilderOptions(
              //         physics: const NeverScrollableScrollPhysics(),
              //         shrinkWrap: true,
              //         padding: EdgeInsets.zero),
              //     // shrinkWrap: true,
              //     horizontalGridSpacing:
              //         50, // Horizontal space between grid items
              //     verticalGridSpacing: 50, // Vertical space between grid items
              //     horizontalGridMargin: 50, // Horizontal space around the grid
              //     verticalGridMargin: 50, // Vertical space around the grid
              //     minItemsPerRow:
              //         2, // The minimum items to show in a single row. Takes precedence over minItemWidth
              //     maxItemsPerRow:
              //         4, // The maximum items to show in a single row. Can be useful on large screens
              //     // sliverChildBuilderDelegateOptions:
              //     //     SliverChildBuilderDelegateOptions(),
              //     minItemWidth: 180,
              //     children: [
              //       ...list
              //           .map((e) => WebGridViewItem(
              //                 item: e,
              //                 setDescriptionAtBottom: false,
              //               ))
              //           .toList(),
              //       if (isLoading)
              //         ...List.generate(
              //             5, (index) => ListHorizontalItemShimmer())
              //     ]);
              return ResponsiveGridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                alignment: Alignment.topCenter,

                // maxRowCount: 4,
                gridDelegate: ResponsiveGridDelegate(
                  mainAxisSpacing:
                      ScreenHelper.isDesktop(context) ? 40.0 : 40.0,
                  crossAxisSpacing: 40.0,

                  maxCrossAxisExtent: ScreenHelper.isTablet(context)
                      ? width / 4
                      : ScreenHelper.isMobile(context)
                          ? width / 2
                          : 250,
                  // Hack to adjust child height
                  childAspectRatio: ScreenHelper.isDesktop(context)
                      ? 1
                      : MediaQuery.of(context).size.aspectRatio * 2,
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

        return FutureBuilder<List<dynamic>?>(
          future: viewAbstract.listCall(
              count: ScreenHelper.isDesktop(context) ? 10 : 4, page: value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
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
                mainAxisSpacing: ScreenHelper.isDesktop(context) ? 40.0 : 20.0,
                crossAxisSpacing: 40.0,
                maxCrossAxisExtent: ScreenHelper.isTablet(context) ||
                        ScreenHelper.isMobile(context)
                    ? width / 2
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
        );
      },
    );
  }
}

class WebGridViewItem extends StatelessWidget {
  final ViewAbstract item;
  final bool setDescriptionAtBottom;
  late WebCategoryGridableInterface _categoryGridable;

  WebGridViewItem(
      {super.key, required this.item, this.setDescriptionAtBottom = false});

  @override
  Widget build(BuildContext context) {
    _categoryGridable = item as WebCategoryGridableInterface;
    // return item.getImageUrl(context) == null
    //     ? Container()
    //     : HoverImage(
    //         image: item.getImageUrl(context)!,
    //       );
    return HoverImage(
      bottomWidget: setDescriptionAtBottom
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  item.getHorizontalCardMainHeader(context),
                  item.getHorizontalCardSubtitle(context),
                ],
              ),
            )
          : null,
      image: item.getImageUrl(context) ?? "",
      // scale: false,
      builder: (isHovered) {
        Widget child = GestureDetector(
          onTap: () {
            ViewAbstract? isMasterToList =
                _categoryGridable.getWebCategoryGridableIsMasterToList(context);
            if (isMasterToList != null) {
              context.goNamed(indexWebMasterToList,
                  pathParameters: {"tableName": item.getTableNameApi()!},
                  queryParameters: {
                    "id": item.iD.toString(),
                  },
                  extra: item);
            } else {
              context.goNamed(indexWebView,
                  pathParameters: {
                    "id": item.iD.toString(),
                    "tableName": item.getTableNameApi()!
                  },
                  extra: item);
            }
          },
          child: setDescriptionAtBottom
              ? _getStack(context, isHovered)
              : _getStack(context, isHovered),
        );
        return child;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 275),
          padding: isHovered
              ? const EdgeInsets.all(kDefaultPadding)
              : EdgeInsets.zero,
          child: child,
        );
      },
    );
  }

  Stack _getStack(BuildContext context, bool isHovered) {
    return Stack(
      children: [
        _buildBackground(context),
        // _buildBackground(context),
        _buildGradient(isHovered),
        _buildTitleAndSubtitle(context, isHovered),
        if (item is CartableProductItemInterface)
          if (item
                  .getCartableProductItemInterface()
                  .getCartableProductQuantity() !=
              0)
            Positioned.fill(
                child: AnimatedOpacity(
              duration: const Duration(milliseconds: 275),
              opacity: isHovered ? 1 : 0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 275),
                scale: isHovered ? 1 : 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      showCartDialog(
                          context, item as CartableProductItemInterface);
                    },
                  ),
                ),
              ),
            ))
        // Positioned(bottom: 0.0, left: 0.0, child: Text("das"))
        // _buildCenterWidget(context)
      ],
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
        child: item.getHeroTag(
      context: context,
      child: Container(
          decoration: BoxDecoration(
              image: item.getImageUrl(context) == null
                  ? null
                  : DecorationImage(
                      image:
                          FastCachedImageProvider(item.getImageUrl(context)!),
                      fit: BoxFit.cover),
              color: null,
              borderRadius: const BorderRadius.all(Radius.circular(18))),
          child: item.getImageUrl(context) == null
              ? item.getImageIfNoUrl()
              : null),
    ));
  }

  Widget _buildGradient(bool isHoverd) {
    return Positioned.fill(
        child: AnimatedContainer(
      duration: const Duration(milliseconds: 275),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isHoverd ? Colors.black.withOpacity(0.7) : Colors.transparent,
            isHoverd ? Colors.black.withOpacity(0.7) : Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.6, 0.95],
        ),
      ),
    )

        //  DecoratedBox(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [
        //         Colors.black.withOpacity(0.7),
        //         Colors.black.withOpacity(0.7)
        //       ],
        //       begin: Alignment.topCenter,
        //       end: Alignment.bottomCenter,
        //       stops: const [0.6, 0.95],
        //     ),
        //   ),
        // ),
        );
  }

  Widget _buildTitleAndSubtitle(BuildContext context, bool isHoverd) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 275),
        opacity: isHoverd ? 1 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.getHorizontalCardMainHeader(context),
            item.getHorizontalCardSubtitle(context),
          ],
        ),
      ),
    );
  }
}

class WebGridViewItemCustom extends StatelessWidget {
  final Widget title;
  final String? subtitle;
  final bool setDescriptionAtBottom;
  final String? imageUrl;
  final Widget? child;
  final bool paddingToInside;
  final void Function()? onClick;
  final bool roundedCorners;
  final bool showChildOnHoverOnly;

  const WebGridViewItemCustom(
      {super.key,
      required this.title,
      this.subtitle,
      this.imageUrl,
      this.roundedCorners = true,
      this.onClick,
      this.child,
      this.paddingToInside = false,
      this.showChildOnHoverOnly = false,
      this.setDescriptionAtBottom = false});

  @override
  Widget build(BuildContext context) {
    return HoverImage(
        roundedCorners: roundedCorners,
        animatedScale: !paddingToInside,
        bottomWidget: setDescriptionAtBottom
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    title,
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.caption,
                      )
                  ],
                ),
              )
            : null,
        image: imageUrl ?? "",
        // scale: false,
        builder: (isHovered) => GestureDetector(
            onTap: () {
              onClick?.call();
            },
            child: paddingToInside
                ? AnimatedScale(
                    scale: isHovered ? 0.95 : 1,
                    duration: const Duration(milliseconds: 175),
                    child: _getStack(context, isHovered),
                  )
                : _getStack(context, isHovered))

        // isHovered
        //     ? Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: _getStack(context, isHovered),
        //       )
        //     : _getStack(context, isHovered)),
        );
  }

  bool canShowChild(bool isHovered) {
    if (showChildOnHoverOnly) return isHovered;
    return true;
  }

  Stack _getStack(BuildContext context, bool isHovered) {
    return Stack(
      children: [
        if (imageUrl != null) _buildBackground(context),
        if (!showChildOnHoverOnly)
          if (child != null && canShowChild(isHovered)) _buildChild(context),
        _buildGradient(isHovered),
        _buildTitleAndSubtitle(context, isHovered),
        if (showChildOnHoverOnly)
          if (child != null && canShowChild(isHovered)) _buildChild(context),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned.fill(
        child: Container(
            // width: 150,
            // height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FastCachedImageProvider(imageUrl!),
                    fit: BoxFit.cover),
                color: null,
                borderRadius: roundedCorners
                    ? const BorderRadius.all(Radius.circular(18))
                    : null)));
  }

  Widget _buildChild(BuildContext context) {
    return Positioned.fill(
        child: Container(
            decoration: BoxDecoration(
                color: null,
                borderRadius: roundedCorners
                    ? BorderRadius.all(Radius.circular(18))
                    : null),
            child: child!));
  }

  Widget _buildGradient(bool isHoverd) {
    return Positioned.fill(
        child: AnimatedContainer(
      duration: const Duration(milliseconds: 275),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isHoverd ? Colors.black.withOpacity(0.7) : Colors.transparent,
            isHoverd ? Colors.black.withOpacity(0.7) : Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.6, 0.95],
        ),
      ),
    ));
  }

  Widget _buildTitleAndSubtitle(BuildContext context, bool isHoverd) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 275),
        opacity: isHoverd ? 1 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            if (subtitle != null)
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.caption,
              )
          ],
        ),
      ),
    );
  }
}
