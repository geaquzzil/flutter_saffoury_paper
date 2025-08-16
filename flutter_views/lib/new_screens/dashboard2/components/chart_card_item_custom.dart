import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/cards.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/details/list_details.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_static_list_new.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_navigation.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class ChartCardItemCustom extends StatelessWidget {
  IconData? icon;
  String title;
  String description;
  String? footer;
  String? footerRight;
  List<ViewAbstract>? list;
  List<GrowthRate>? listGrowthRate;
  Widget? footerWidget;
  Widget? footerRightWidget;
  Color? color;
  bool isSmall;
  Animation<double>? animation;
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final SecoundPaneHelperWithParentValueNotifier? basePage;
  void Function()? onTap;
  ChartCardItemCustom({
    this.color,
    required this.title,
    required this.description,
    this.icon,
    this.footer,
    this.animation,
    this.list,
    this.listGrowthRate,
    this.basePage,
    this.isSmall = true,
    this.footerRight,
    this.footerWidget,
    this.onTap,
    this.footerRightWidget,
  }) : super(key: ValueKey(title + description));

  // final CloudStorageInfo info;
  Widget _animationWidget({required Widget child}) {
    return animation != null
        ? FadeTransition(
            opacity: animation!,
            child: SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation!,
              child: child,
            ),
          )
        : !isSmall
        ? child
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    // Widget card = GestureDetector(
    //   onTap: onTap ??
    //       () {
    //         if (list == null) {
    //           return;
    //         }
    //         if (list!.isEmpty) {
    //           return;
    //         }

    //         context.pushNamed(dashboardRouteName, pathParameters: {
    //           "tableName": list![0].getMainHeaderLabelTextOnly(context)
    //         }, extra: [
    //           this,
    //           list
    //         ]);
    //         //navigate to list page
    //       },
    //   child: getBody(context),
    // );
    // Widget c;
    // if (list == null) {
    //   c = Text("dasda");
    // }
    // if (list!.isEmpty) {
    //   c = Text("dsadassa");
    // }

    // c = Text("sdadas");

    Widget card = getBody(context);
    if (list == null || (list?.isEmpty ?? true)) {
      return card;
    }
    if (basePage != null) {
      return InkWell(
        onTap: () {
          basePage?.notifyListWidget(title, [
            SliverApiMixinStaticList(list: list!, state: basePage),
          ]);
        },
        child: card,
      );
    }
    if (onTap != null) {
      return InkWell(onTap: onTap, child: card);
    }
    // return card;
    return CustomPopupMenu(
      pressType: PressType.singleClick,
      position: PreferredPosition.bottom,
      menuBuilder: () => SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.height * .5,
        child: DashboardListDetails(
          header: this,
          list: list!,
          wrapWithScaffold: true,
        ),
      ),
      child: card,
    );
    // return InkWell(
    //   onTap: _tooltipController.toggle,
    //   child: OverlayPortal(
    //     controller: _tooltipController,
    //     overlayChildBuilder: (cxc) {
    //       return Positioned(
    //         right: 0,
    //         bottom: 0,
    //         child: Container(
    //           width: 400,
    //           height: 400,
    //           color: Colors.white,
    //           child: c,
    //         ),
    //       );
    //       return Positioned(
    //         right: 50,
    //         bottom: 50,
    //         child: SizedBox(
    //           height: 400,
    //           width: 400,
    //           child: DashboardListDetails(
    //             list: list!,
    //             header: this,
    //             wrapWithScaffold: true,
    //           ),
    //         ),
    //       );
    //     },
    //     child: card,
    //   ),
    // );

    // return InkWell(
    //   // focusColor: color,

    //   hoverColor: color == null
    //       ? null
    //       : ElevationOverlay.colorWithOverlay(
    //           Theme.of(context).colorScheme.surface, color!, 3),
    //   // onTap: ,
    //   onTap: _tooltipController.toggle,
    //   child: OverlayPortal(
    //     controller: _tooltipController,
    //     overlayChildBuilder: (c) {
    //       Widget c;
    //       if (list == null) {
    //         c = Text("dasda");
    //       }
    //       if (list!.isEmpty) {
    //         c = Text("dsadassa");
    //       }
    //       c = Text("sdadas");
    //       return Positioned(
    //         right: 50,
    //         bottom: 50,
    //         child: Container(
    //           width: 400,
    //           height: 400,
    //           color: Colors.white,
    //           child: c,
    //         ),
    //       );
    //       return Positioned(
    //         right: 50,
    //         bottom: 50,
    //         child: SizedBox(
    //           height: 400,
    //           width: 400,
    //           child: DashboardListDetails(
    //             list: list!,
    //             header: this,
    //             wrapWithScaffold: true,
    //           ),
    //         ),
    //       );
    //     },
    //     child: Hero(
    //         tag: getHeroTag(),
    //         flightShuttleBuilder: (
    //           BuildContext flightContext,
    //           Animation<double> animation,
    //           HeroFlightDirection flightDirection,
    //           BuildContext fromHeroContext,
    //           BuildContext toHeroContext,
    //         ) {
    //           return ChartCardItemCustom(
    //             title: title,
    //             description: description,
    //             list: list,
    //             color: color,
    //             footer: footer,
    //             footerRight: footerRight,
    //             footerWidget: footerWidget,
    //             footerRightWidget: footerRightWidget,
    //             icon: icon,
    //             isSmall: false,
    //             animation: ReverseAnimation(animation),
    //           );
    //         },
    //         child: card),
    //   ),
    // );
  }

  Widget getBody(BuildContext context) {
    return Cards(
      type: CardType.normal,
      enableScaling: true,
      toScaleDown: true,
      colorWithOverlay: color,
      // color: color == null
      //     ? null
      //     : ElevationOverlay.colorWithOverlay(
      //         Theme.of(context).colorScheme.surface,
      //         color!,
      //         3,
      //       ),

      // color?.withValues(alpha:0.2),
      child: (b) => Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!,
              ),
              trailing: (icon != null) ? Icon(icon) : null,
            ),

            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              // overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge!,
            ),
            if (listGrowthRate != null)
              LineChartItem<GrowthRate, String>(
                smallView: true,
                color: color,
                list: listGrowthRate!,
                title: title,
                // title:
                //     CutRequest().getMainHeaderLabelTextOnly(context),
                dataLabelMapper: (item, idx) => item.total?.toCurrencyFormat(),
                xValueMapper: (item, value) {
                  // debugPrint("ChartItem $item");
                  return DateFormat.yMMM().format(
                    DateTime(item.year!, item.month!, item.day ?? 1),
                  );
                },
                yValueMapper: (item, n) => item.total,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (footerWidget != null) footerWidget!,
                if (footer != null)
                  Text(
                    footer!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                if (footerRight != null)
                  Text(
                    footerRight!,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                if (footerRightWidget != null) footerRightWidget!,
              ],
            ),
            // if (!isSmall)
            //   Text("this is not a small widget",
            //       style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ),
    );
  }

  String getHeroTag() {
    return title + description;
  }
}

// enum OVERLAY_POSITION { TOP, BOTTOM }

// class ScriptureDisplay extends StatefulWidget {
//   @override
//   _ScriptureDisplayState createState() => _ScriptureDisplayState();
// }

// class _ScriptureDisplayState extends State<ScriptureDisplay> {
//   TapDownDetails _tapDownDetails;
//   OverlayEntry _overlayEntry;
//   OVERLAY_POSITION _overlayPosition;

//   double _statusBarHeight;
//   double _toolBarHeight;

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject();

//     var size = renderBox.size;

//     var offset = renderBox.localToGlobal(Offset.zero);
//     var globalOffset = renderBox.localToGlobal(_tapDownDetails.globalPosition);

//     _statusBarHeight = MediaQuery.of(context).padding.top;

//     // TODO: Calculate ToolBar Height Using MediaQuery
//     _toolBarHeight = 50;
//     var screenHeight = MediaQuery.of(context).size.height;

//     var remainingScreenHeight =
//         screenHeight - _statusBarHeight - _toolBarHeight;

//     if (globalOffset.dy > remainingScreenHeight / 2) {
//       _overlayPosition = OVERLAY_POSITION.TOP;
//     } else {
//       _overlayPosition = OVERLAY_POSITION.BOTTOM;
//     }
//     return OverlayEntry(builder: (context) {
//       return Stack(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () {
//               _overlayEntry.remove();
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               color: Colors.blueGrey.withValues(alpha:0.1),
//             ),
//           ),
//           Positioned(
//             left: 10,
//             top: _overlayPosition == OVERLAY_POSITION.TOP
//                 ? _statusBarHeight + _toolBarHeight
//                 : offset.dy + size.height - 5.0,
//             width: MediaQuery.of(context).size.width - 20,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 // ignore: sdk_version_ui_as_code
//                 if (_overlayPosition == OVERLAY_POSITION.BOTTOM) nip(),
//                 body(context, offset.dy),
//                 // ignore: sdk_version_ui_as_code
//                 if (_overlayPosition == OVERLAY_POSITION.TOP) nip(),
//               ],
//             ),
//           )
//         ],
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 400, left: 10, right: 100),
//       child: GestureDetector(
//         child: Text("C"),
//         onTapDown: (TapDownDetails tapDown) {
//           setState(() {
//             _tapDownDetails = tapDown;
//           });
//           this._overlayEntry = this._createOverlayEntry();
//           Overlay.of(context).insert(this._overlayEntry);
//         },
//       ),
//     );
//   }

//   Widget body(BuildContext context, double offset) {
//     return Material(
//       borderRadius: BorderRadius.all(
//         Radius.circular(8.0),
//       ),
//       elevation: 4.0,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: _overlayPosition == OVERLAY_POSITION.BOTTOM
//             ? MediaQuery.of(context).size.height -
//                 _tapDownDetails.globalPosition.dy -
//                 20
//             : _tapDownDetails.globalPosition.dy -
//                 _toolBarHeight -
//                 _statusBarHeight -
//                 15,
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           shrinkWrap: true,
//           children: [
//             "First",
//             "Second",
//             "Third",
//             "First",
//             "Second",
//             "Third",
//             "First",
//             "Second",
//             "Third"
//           ]
//               .map((String s) => ListTile(
//                     subtitle: Text(s),
//                   ))
//               .toList(growable: false),
//         ),
//       ),
//     );
//   }

//   Widget nip() {
//     return Container(
//       height: 10.0,
//       width: 10.0,
//       margin: EdgeInsets.only(left: _tapDownDetails.globalPosition.dx),
//       child: CustomPaint(
//         painter: OpenPainter(_overlayPosition),
//       ),
//     );
//   }
// }

// class OpenPainter extends CustomPainter {
//   final OVERLAY_POSITION overlayPosition;

//   OpenPainter(this.overlayPosition);

//   @override
//   void paint(Canvas canvas, Size size) {
//     switch (overlayPosition) {
//       case OVERLAY_POSITION.TOP:
//         var paint = Paint()
//           ..style = PaintingStyle.fill
//           ..color = Colors.white
//           ..isAntiAlias = true;

//         _drawThreeShape(canvas,
//             first: Offset(0, 0),
//             second: Offset(20, 0),
//             third: Offset(10, 15),
//             size: size,
//             paint: paint);

//         break;
//       case OVERLAY_POSITION.BOTTOM:
//         var paint = Paint()
//           ..style = PaintingStyle.fill
//           ..color = Colors.white
//           ..isAntiAlias = true;

//         _drawThreeShape(canvas,
//             first: Offset(15, 0),
//             second: Offset(0, 20),
//             third: Offset(30, 20),
//             size: size,
//             paint: paint);

//         break;
//     }

//     canvas.save();
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;

//   void _drawThreeShape(Canvas canvas,
//       {Offset first, Offset second, Offset third, Size size, paint}) {
//     var path1 = Path()
//       ..moveTo(first.dx, first.dy)
//       ..lineTo(second.dx, second.dy)
//       ..lineTo(third.dx, third.dy);
//     canvas.drawPath(path1, paint);
//   }

//   void _drawTwoShape(Canvas canvas,
//       {Offset first, Offset second, Size size, paint}) {
//     var path1 = Path()
//       ..moveTo(first.dx, first.dy)
//       ..lineTo(second.dx, second.dy);
//     canvas.drawPath(path1, paint);
//   }
// }
