import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SearchWidgetComponent extends StatefulWidget {
  TextEditingController controller;
  bool forceSearchBarAsEditText;
  Function(String?) onSearchTextChanged;
  SearchWidgetComponent(
      {super.key,
      required this.controller,
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
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.forward();
    widget.controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: kDefaultPadding / 2,
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2),
      child: Hero(
        tag: "/search",
        child: Card(
          // color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            leading: getLeadingWidget(),
            onTap: SizeConfig.isMobile(context) ||
                    SizeConfig.isFoldable(context) &&
                        !widget.forceSearchBarAsEditText
                ? () {
                    Navigator.pushNamed(context, "/search", arguments: null);
                  }
                : null,
            title: (SizeConfig.isMobile(context) ||
                        SizeConfig.isFoldable(context)) &&
                    !widget.forceSearchBarAsEditText
                ? Text(AppLocalizations.of(context)!.searchInFormat(context
                    .watch<DrawerViewAbstractListProvider>()
                    .getObject
                    .getMainHeaderLabelTextOnly(context)))
                : TextField(
                    controller: widget.controller,
                  ),
            trailing: getTrailingWidget(),
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

  Widget getLeadingWidget() {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.arrow_menu,
        progress: _animationController,
      ),
      onPressed: () {
        context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
      },
    );
  }

  Widget? getTrailingWidget() {
    if (SizeConfig.isMobile(context)) {
      if (context.watch<CartProvider>().getCount == 0) return null;
      return Badge(
        badgeColor: Theme.of(context).colorScheme.primary,
        badgeContent: Text(
          "${context.watch<CartProvider>().getCount}",
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        toAnimate: true,
        animationType: BadgeAnimationType.scale,
        animationDuration: const Duration(milliseconds: 50),
        showBadge: context.watch<CartProvider>().getCount > 0,
        child: buildColapsedIcon(
          context,
          Icons.shopping_cart_rounded,
          () {
            context.read<DrawerMenuControllerProvider>().controlEndDrawerMenu();
          },
        ),
      );
    } else {
      return null;
    }
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.close_menu,
        progress: _animationController,
      ),
      onPressed: () {
        widget.controller.clear();
        widget.onSearchTextChanged('');
        _handleOnPressed();
      },
    );
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
