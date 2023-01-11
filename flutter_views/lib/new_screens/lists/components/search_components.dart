import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SearchWidgetComponent extends StatefulWidget {
  TextEditingController? controller;
  bool forceSearchBarAsEditText;
  String heroTag;
  Function(String?) onSearchTextChanged;
  ValueNotifier<ExpandType>? appBardExpandType;
  SearchWidgetComponent(
      {super.key,
      this.heroTag = "/search",
      this.controller,
      this.appBardExpandType,
      required this.onSearchTextChanged,
      this.forceSearchBarAsEditText = false});

  @override
  State<SearchWidgetComponent> createState() => _SearchWidgetComponentState();
}

class _SearchWidgetComponentState extends State<SearchWidgetComponent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.forward();
    widget.controller?.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: kDefaultPadding / 2,
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2),
      child: Hero(
        tag: widget.heroTag,
        child: Card(
          // elevation: 3,
          // color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            leading: getLeadingWidget(context),
            onTap: () => context.goNamed(searchRouteName, queryParams: {
              "query": "q"
            },
                // extra: [
                //   context.read<DrawerMenuControllerProvider>().getObject,
                //   widget.heroTag
                // ] ,
                params: {
                  "tableName": context
                      .read<DrawerMenuControllerProvider>()
                      .getObject
                      .getTableNameApi()!
                }),
            title: Selector<DrawerMenuControllerProvider, ViewAbstract>(
              builder: (context, value, child) {
                return Text(
                  AppLocalizations.of(context)!.searchInFormat(
                      value.getMainHeaderLabelTextOnly(context)),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                );
              },
              selector: (p0, p1) => p1.getObject,
            ),
            trailing: CartIconWidget(
              onPressed: () {
                context
                    .read<DrawerMenuControllerProvider>()
                    .controlEndDrawerMenu();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  // Widget? getLeadingWidget() {
  //   // if (SizeConfig.isLargeScreen(context)) return null;
  //   return IconButton(
  //     icon: AnimatedIcon(
  //       icon: AnimatedIcons.arrow_menu,
  //       progress: _animationController,
  //     ),
  //     onPressed: () {
  //       context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
  //     },
  //   );
  // }

  Widget? getLeadingWidget(BuildContext context) {
    // if (SizeConfig.isLargeScreen(context)) return null;
    Widget icon = IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.arrow_menu,
        progress: _animationController,
      ),
      onPressed: () {
        context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
      },
    );
    if (widget.appBardExpandType == null) {
      return icon;
    } else {
      return ValueListenableBuilder<ExpandType>(
        valueListenable: widget.appBardExpandType!,
        builder: (context, value, child) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: value == ExpandType.CLOSED ? 1 : 0,
            child: icon,
          );
        },
      );
    }
  }

  OnHoverWidget buildColapsedIcon(
      BuildContext context, IconData data, VoidCallback? onPress) {
    return OnHoverWidget(
        scale: false,
        builder: (onHover) {
          return IconButton(
              // padding: EdgeInsets.all(4),
              onPressed: onPress,
              iconSize: 25,
              icon: Icon(data),
              color: onHover
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary);
        });
  }
}
