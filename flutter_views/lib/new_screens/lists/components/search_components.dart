import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

class SearchWidgetComponent extends StatefulWidget {
  TextEditingController controller;
  Function(String?) onSearchTextChanged;
  SearchWidgetComponent(
      {super.key, required this.controller, required this.onSearchTextChanged});

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
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: getLeadingWidget(),
          title: TextField(
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
            controller: widget.controller,
            decoration: const InputDecoration(
                hintText: 'Search', border: InputBorder.none),
            onChanged: widget.onSearchTextChanged,
          ),
          trailing: getTrailingWidget(),
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