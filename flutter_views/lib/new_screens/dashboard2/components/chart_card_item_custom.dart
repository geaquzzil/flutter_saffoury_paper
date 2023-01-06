import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../constants.dart';

class ChartCardItemCustom extends StatelessWidget {
  IconData? icon;
  String title;
  String description;
  String? footer;
  String? footerRight;
  List<ViewAbstract>? list;
  Widget? footerWidget;
  Widget? footerRightWidget;
  Color? color;
  bool isSmall;
  Animation<double>? animation;
  void Function()? onTap;
  ChartCardItemCustom(
      {Key? key,
      this.color,
      required this.title,
      required this.description,
      this.icon,
      this.footer,
      this.animation,
      this.list,
      this.isSmall = true,
      this.footerRight,
      this.footerWidget,
      this.onTap,
      this.footerRightWidget})
      : super(key: key);

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
            context.pushNamed(dashboardRouteName, params: {
              "tableName": list![0].getMainHeaderLabelTextOnly(context)
            }, extra: [
              this,
              list
            ]);
            //navigate to list page
          },
      child: Card(
        color: color?.withOpacity(0.1),
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
                  if (icon != null)
                    Container(
                        padding: const EdgeInsets.all(defaultPadding / 8),
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          // color: Colors.orange.withOpacity(0.1),
                          // color: info.color!.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(icon)),
                  if (icon != null)
                    Icon(
                      Icons.deblur_outlined,
                    )
                ],
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption!,
              ),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (footerWidget != null) footerWidget!,
                  if (footer != null)
                    Text(footer!, style: Theme.of(context).textTheme.caption!),
                  if (footerRight != null)
                    Text(footerRight!,
                        style: Theme.of(context).textTheme.caption!),
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
