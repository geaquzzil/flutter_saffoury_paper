import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item_master_horizontal.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/components/list_web_api_master.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GridViewApi extends StatelessWidget {
  final ViewAbstract viewAbstract;
  double? customHeight;

  ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> valuePageNotifier = ValueNotifier<int>(0);
  GridViewApi({super.key, this.customHeight, required this.viewAbstract});

  @override
  Widget build(BuildContext context) {
    customHeight =
        customHeight ??
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
                children: [_buildUi(context, width), getButtons()],
              ),
            );
          },
        );
        return SizedBox(
          width: double.infinity,
          height: customHeight,
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ScreenHelper(
                      largeTablet: _buildUi(context, kDesktopMaxWidth),
                      smallTablet: _buildUi(context, kTabletMaxWidth),
                      mobile: _buildUi(context, getMobileMaxWidth(context)),
                    ),
                  ),
                ),
              ),
              getButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget getButtons() {
    return HoverButtons(
      valueNotifier: valueNotifier,
      valuePageNotifier: valuePageNotifier,
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
            customCount: isDesktop(context)
                ? 10
                : isTablet(context)
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
                  mainAxisSpacing: isDesktop(context) ? 40.0 : 40.0,
                  crossAxisSpacing: 40.0,

                  maxCrossAxisExtent: isTablet(context)
                      ? width / 4
                      : isMobile(context)
                      ? width / 2
                      : 250,
                  // Hack to adjust child height
                  childAspectRatio: isDesktop(context)
                      ? 1
                      : MediaQuery.of(context).size.aspectRatio * 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var designProcesse = list[index];
                  return ListCardItemMasterHorizontal(object: designProcesse);
                },
                itemCount: list.length,
              );
            },
          ),
        );

        // return FutureBuilder<List<dynamic>?>(
        //   future: viewAbstract.listCall(
        //       count: isDesktop(context) ? 10 : 4, page: value,context: context),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const CircularProgressIndicator();
        //     }
        //     List<ViewAbstract>? list = snapshot.data?.cast();
        //     if (list == null) {
        //       return Container();
        //     }

        //     return ResponsiveGridView.builder(
        //       padding: const EdgeInsets.all(0.0),
        //       shrinkWrap: true,
        //       physics: const NeverScrollableScrollPhysics(),
        //       alignment: Alignment.topCenter,
        //       gridDelegate: ResponsiveGridDelegate(
        //         mainAxisSpacing: isDesktop(context) ? 40.0 : 20.0,
        //         crossAxisSpacing: 40.0,
        //         maxCrossAxisExtent:
        //             isTablet(context) || isMobile(context) ? width / 2 : 250,
        //         // Hack to adjust child height
        //         childAspectRatio: isDesktop(context)
        //             ? 1
        //             : MediaQuery.of(context).size.aspectRatio * 1.5,
        //       ),
        //       itemBuilder: (BuildContext context, int index) {
        //         var designProcesse = list[index];
        //         return WebGridViewItem(
        //           item: designProcesse,
        //         );
        //       },
        //       itemCount: list.length,
        //     );
        //   },
        // );
      },
    );
  }
}

class HoverButtons extends StatelessWidget {
  HoverButtons({
    super.key,
    required this.valueNotifier,
    this.valuePageNotifier,
    this.valuePageNotifierVoid,
  });

  final ValueNotifier<bool> valueNotifier;
  final ValueNotifier<int>? valuePageNotifier;
  final Function(int idx, bool isNext)? valuePageNotifierVoid;

  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 275),
            opacity: value ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedIconButton(
                  icon: Icons.arrow_back_ios_new_sharp,
                  onTap: () {
                    int i = valuePageNotifier?.value ?? idx;

                    if (i == 0) return;
                    idx = i - 1;
                    if (valuePageNotifierVoid != null) {
                      valuePageNotifierVoid!.call(idx, false);
                    }
                    if (valuePageNotifier != null) {
                      valuePageNotifier?.value = idx;
                    }
                  },
                ),
                RoundedIconButton(
                  onTap: () {
                    int i = valuePageNotifier?.value ?? idx;
                    idx = i + 1;
                    if (valuePageNotifierVoid != null) {
                      valuePageNotifierVoid!.call(idx, true);
                    }
                    if (valuePageNotifier != null) {
                      valuePageNotifier?.value = idx;
                    }
                  },
                  icon: Icons.arrow_forward_ios_sharp,
                ),
              ],
            ),
          ),
        );
      },
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

  const WebGridViewItemCustom({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.roundedCorners = true,
    this.onClick,
    this.child,
    this.paddingToInside = false,
    this.showChildOnHoverOnly = false,
    this.setDescriptionAtBottom = false,
  });

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
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
            : _getStack(context, isHovered),
      ),

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
            fit: BoxFit.cover,
          ),
          color: null,
          borderRadius: roundedCorners
              ? const BorderRadius.all(Radius.circular(18))
              : null,
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: null,
          borderRadius: roundedCorners
              ? const BorderRadius.all(Radius.circular(18))
              : null,
        ),
        child: child!,
      ),
    );
  }

  Widget _buildGradient(bool isHoverd) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 275),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isHoverd ? Colors.black.withValues(alpha:0.7) : Colors.transparent,
              isHoverd ? Colors.black.withValues(alpha:0.7) : Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
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
            title,
            if (subtitle != null)
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
