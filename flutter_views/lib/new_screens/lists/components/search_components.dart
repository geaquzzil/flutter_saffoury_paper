import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/draggable_home.dart';
import 'package:flutter_view_controller/encyptions/compressions.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/cart/cart_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/our_products.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/debouncer.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SearchWidgetWebComponent extends StatelessWidget {
  final ValueNotifier<double> scrollvalueNofifier;
  Function(String v)? onSearchTextChanged;
  SearchWidgetWebComponent(
      {super.key, this.onSearchTextChanged, required this.scrollvalueNofifier});
  Widget getSearchTitleEditable(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (value) async {
        if (value.isEmpty) return;
        debugPrint("onSubmitted $value");
        onSearchTextChanged?.call(value);
      },
      decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: AppLocalizations.of(context)?.search,
          border: InputBorder.none),
    );
  }

  Widget? getLeadingWidget(BuildContext context) {
    // if (SizeConfig.isLargeScreen(context)) return null;
    Widget icon = IconButton(
      icon: const Icon(
        Icons.menu,
      ),
      onPressed: () {
        context.read<DrawerMenuControllerProvider>().controlStartDrawerMenu();
      },
    );

    return ValueListenableBuilder<double>(
      valueListenable: scrollvalueNofifier,
      builder: (context, value, child) {
        return AnimatedScale(
          duration: const Duration(milliseconds: 275),
          scale: value > 100 ? 1 : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 275),
            opacity: value > 100 ? 1 : 0,
            child: icon,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: kDefaultPadding / 2,
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2),
      child: CardCorner(
        // elevation: 3,
        // color: Theme.of(context).colorScheme.primary,
        child: ListTile(
            leading: getLeadingWidget(context),
            title: getSearchTitleEditable(context),
            trailing: Wrap(children: [
              const Spacer(),
              ValueListenableBuilder<double>(
                valueListenable: scrollvalueNofifier,
                builder: (context, value, child) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 275),
                    opacity: value > 100 ? 1 : 0,
                    child: CartIconWidget(
                      onPressed: () {
                        context
                            .read<DrawerMenuControllerProvider>()
                            .controlEndDrawerMenu();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                  onPressed: () async {
                    await ProductWebPage.showFilterDialog(
                            context,
                            context
                                .read<AuthProvider<AuthUser>>()
                                .getWebCategories()[0]
                                .getNewInstance())
                        .then((value) {
                      if (value == null) return;
                      String compressed = Compression.compress(value);
                      debugPrint("Compressing $compressed");
                      context.goNamed(indexWebOurProducts,
                          queryParams: {"filter": Compression.compress(value)});
                      // context.read<DrawerMenuControllerProvider>().changeWithFilterable(context, v);
                    });
                  },
                  icon: const Icon(Icons.filter_alt)),
            ])),
      ),
    );
  }
}

class SearchWidgetComponent extends StatefulWidget {
  String heroTag;
  ViewAbstract? viewAbstract;
  Function(String)? onSearchTextChanged;
  ValueNotifier<String>? onSearchTextChangedValueNotifier;
  ValueNotifier<ExpandType>? appBardExpandType;
  SearchWidgetComponent(
      {super.key,
      this.heroTag = "/search",
      this.appBardExpandType,
      this.onSearchTextChangedValueNotifier,
      this.onSearchTextChanged});

  @override
  State<SearchWidgetComponent> createState() => _SearchWidgetComponentState();
}

class _SearchWidgetComponentState extends State<SearchWidgetComponent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool isPlaying = false;
  bool isEditText = false;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.forward();
    isEditText = widget.onSearchTextChanged != null ||
        widget.onSearchTextChangedValueNotifier != null;
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
        child: CardCorner(
          // elevation: 3,
          // color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            leading: getLeadingWidget(context),
            onTap: isEditText
                ? null
                : () => context.goNamed(searchRouteName, queryParams: {
                      "query": "q"
                    }, params: {
                      "tableName": context
                          .read<DrawerMenuControllerProvider>()
                          .getObject
                          .getTableNameApi()!
                    }),
            title: isEditText
                ? getSearchTitleEditable()
                : getSearchTitleClickable(),
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

  Widget getSearchTitleEditable() {
    return TextField(
      textInputAction: TextInputAction.search,
      onSubmitted: (value) async {
        debugPrint("onSubmitted $value");
        callDebouncer(value);
      },
      decoration: InputDecoration(
          fillColor: Colors.transparent,
          hintText: widget.viewAbstract == null
              ? AppLocalizations.of(context)?.search
              : getSearchHint(widget.viewAbstract!),
          border: InputBorder.none),
    );
  }

  void callDebouncer(String query) {
    _debouncer.run(() async {
      widget.onSearchTextChanged?.call(query);
      widget.onSearchTextChangedValueNotifier?.value = query;
    });
  }

  String getSearchHint(ViewAbstract value) {
    return AppLocalizations.of(context)!
        .searchInFormat(value.getMainHeaderLabelTextOnly(context));
  }

  Selector<DrawerMenuControllerProvider, ViewAbstract<dynamic>>
      getSearchTitleClickable() {
    return Selector<DrawerMenuControllerProvider, ViewAbstract>(
      builder: (context, value, child) {
        return Text(
          getSearchHint(value),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        );
      },
      selector: (p0, p1) => p1.getObject,
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
