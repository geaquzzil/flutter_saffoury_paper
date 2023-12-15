import 'package:flutter/material.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/apis/growth_rate.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/chart/line_chart.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/dashboard.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  void Function()? onTap;
  ChartCardItemCustom(
      {super.key,
      this.color,
      required this.title,
      required this.description,
      this.icon,
      this.footer,
      this.animation,
      this.list,
      this.listGrowthRate,
      this.isSmall = true,
      this.footerRight,
      this.footerWidget,
      this.onTap,
      this.footerRightWidget});

  // final CloudStorageInfo info;
  Widget _animationWidget({required Widget child}) {
    return animation != null
        ? FadeTransition(
            opacity: animation!,
            child: SizeTransition(
                axisAlignment: 1.0, sizeFactor: animation!, child: child))
        : !isSmall
            ? child
            : Container();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = GestureDetector(
      onTap: onTap ??
          () {
            if (list == null) {
              return;
            }
            if (list!.isEmpty) {
              return;
            }
            context.pushNamed(dashboardRouteName, pathParameters: {
              "tableName": list![0].getMainHeaderLabelTextOnly(context)
            }, extra: [
              this,
              list
            ]);
            //navigate to list page
          },
      child: Card(
        // color: color?.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!,
                  ),
                  if (icon != null) Icon(icon)
                ],
              ),

              Text(
                description,
                maxLines: 2,
                // overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
              if (listGrowthRate != null)
                Container(
                  // transform: Matrix4.translationValues(-20.0, 0, -20.0),
                  child: LineChartItem<GrowthRate, String>(
                    smallView: true,
                    list: listGrowthRate!,
                    // title:
                    //     CutRequest().getMainHeaderLabelTextOnly(context),
                    dataLabelMapper: (item, idx) =>
                        item.total?.toCurrencyFormat(),
                    xValueMapper: (item, value) {
                      debugPrint("ChartItem $item");
                      return DateFormat.MMM().format(
                          DateTime(item.year!, item.month!, item.day ?? 1));
                    },
                    yValueMapper: (item, n) => item.total,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (footerWidget != null) footerWidget!,
                  if (footer != null)
                    Text(footer!,
                        style: Theme.of(context).textTheme.bodySmall!),
                  if (footerRight != null)
                    Text(footerRight!,
                        style: Theme.of(context).textTheme.bodySmall!),
                  if (footerRightWidget != null) footerRightWidget!
                ],
              ),
              // if (!isSmall)
              //   Text("this is not a small widget",
              //       style: Theme.of(context).textTheme.titleLarge)
            ],
          ),
        ),
      ),
    );

    return Hero(
        tag: getHeroTag(),
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          return ChartCardItemCustom(
            title: title,
            description: description,
            list: list,
            color: color,
            footer: footer,
            footerRight: footerRight,
            footerWidget: footerWidget,
            footerRightWidget: footerRightWidget,
            icon: icon,
            isSmall: false,
            animation: ReverseAnimation(animation),
          );
        },
        child: card);
  }

  String getHeroTag() {
    return title + description;
  }
}
