// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/interfaces/dashable_interface.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/actions/dashboard/base_dashboard_screen_page.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/setting_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_on_open_drawer.dart';
import 'package:flutter_view_controller/new_screens/routes.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/components/header.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../profile/profile_pic_popup_menu.dart';
import 'components/ext.dart';

class DrawerMenuItem {
  Function? onTap;
  Function? onTapLeading;
  String title;
  String? description;
  IconData icon;

  String? key;
  DrawerMenuItem({
    this.onTap,
    required this.title,
    this.key,
    this.description,
    this.onTapLeading,
    required this.icon,
  });
  String getTooltip() {
    return this.title;
  }
}

class DrawerLargeScreens extends StatefulWidget {
  CurrentScreenSize? size;
  double? width;
  double? height;
  Map<String, List<DrawerMenuItem>>? customItems;
  DrawerLargeScreens(
      {super.key, this.size, this.customItems, this.width, this.height});

  @override
  State<DrawerLargeScreens> createState() => _DrawerLargeScreensState();
}

class _DrawerLargeScreensState extends State<DrawerLargeScreens>
    with TickerProviderStateMixin {
  CurrentScreenSize? _size;

  double? _width;
  double? _height;
  final padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding);

  late DrawerMenuControllerProvider drawerMenuControllerProvider;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.forward();
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
    _size = widget.size;
    _width = widget.width;
    _height = widget.height;
    super.initState();
    debugPrint("DrawerLargeScreens initState");
  }

  @override
  void didUpdateWidget(covariant DrawerLargeScreens oldWidget) {
    super.didUpdateWidget(oldWidget);
    _size = widget.size;
    _width = widget.width;
    _height = widget.height;
    if (canSmallDrawerWhenOpen()) {
      WidgetsBinding.instance.addPostFrameCallback((c) {
        if (drawerMenuControllerProvider.getSideMenuIsClosed) {
          drawerMenuControllerProvider.setSideMenuIsOpen();
        }
      });
    }
  }

  bool canSmallDrawerWhenOpen() {
    return showHamburger(_size);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DrawerMenuControllerProvider, bool>(
      builder: (__, isOpen, ___) {
        return getBodyScaffold(isOpen, __);
      },
      selector: (p0, p1) => p1.getSideMenuIsOpen,
    );
  }

  Widget getBodyScaffold(bool isOpen, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
      width: showHamburger(_size)
          ? kDrawerOpenWidth
          : isOpen
              ? kDrawerOpenWidth
              : kDefaultClosedDrawer,
      height: _height,
      child:
          _getDrawerBodyScaffold(context, showHamburger(_size) ? true : isOpen),
    );
  }

  Widget _getDrawerBodyScaffold(BuildContext context, bool isOpen) {
    bool isLarge = isLargeScreenFromCurrentScreenSize(context);
    return Scaffold(
      bottomNavigationBar: !isLarge ? buildDrawerFooter(context, isOpen) : null,
      body: CustomScrollView(
        controller: ScrollController(),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegatePreferedSize(
                  shouldRebuildWidget: true,
                  child: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: buildHeader(context, isOpen)))),
          ...buildListSlivers(context, isOpen)
        ],
      ),
    );
  }

  Widget buildDrawerFooter(BuildContext context, bool isOpen) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        direction: isOpen ? Axis.horizontal : Axis.vertical,
        children: [
          if (isOpen)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.goNamed(settingsRouteName);
              },
            ),
          if (isOpen)
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                context.goNamed(notificationRouteName);
              },
            ),
          if (isOpen) const Expanded(child: DrawerLanguageButton()),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, bool isOpen) {
    return Card(
      margin: EdgeInsets.zero,
      child: IconButton(
        onPressed: () {
          if (showHamburger(_size)) {
            drawerMenuControllerProvider.controlStartDrawerMenu();
          } else {
            drawerMenuControllerProvider.toggleIsOpen();
            if (drawerMenuControllerProvider.getSideMenuIsOpen) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
          }
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.arrow_menu, progress: _animationController),
      ),
    );
  }

  List<Widget> buildListSlivers(BuildContext context, bool isOpen) {
    List<Widget> widgets = List.empty(growable: true);
    AuthProvider authProvider = Provider.of<AuthProvider<AuthUser>>(context);
    Map<String?, List> l =
        widget.customItems ?? authProvider.getDrawerItemsGrouped;

    for (var a in l.entries) {
      List list = a.value;
      String? key = a.key;
      GlobalKey buttonKey = GlobalKey();
      var group = [
        SectionItemHeaderI(
            context: context,
            pinHeader: isOpen,
            pinHeaderPrefferedSize: 4,
            title: AnimatedSwitcher(
              duration: Duration(milliseconds: 1500),
              child: isOpen
                  ? Text(
                      key ?? "_",
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  : Divider(),
            ),
            buttonKey: buttonKey,
            child: Column(
                children: list.map((p) {
              DrawerMenuItem item = (p is DrawerMenuItem)
                  ? p
                  : DrawerMenuItem(
                      onTapLeading: () {
                        p.onDrawerLeadingItemClicked(context);
                      },
                      onTap: () {
                        p.onDrawerItemClicked(context);
                      },
                      title: p.getMainHeaderLabelTextOnly(context),
                      icon: p.getMainIconData());

              return AnimatedSwitcher(
                duration: Duration(milliseconds: 600),
                child: (isOpen)
                    ? DrawerListTileDesktopOpen(item: item)
                    : DrawerListTileDesktopClosed(
                        item: item,
                      ),
              );
            }).toList())),
      ];
      widgets.addAll(group);
    }
    return widgets;
  }

  Widget buildProfilePic(BuildContext context, bool isOpen) {
    return isOpen
        ? ProfileOnOpenDrawerWidget()
        : const ProfilePicturePopupMenu();
  }

  Widget buildCollapseIcon(BuildContext context, bool isOpen) {
    const double size = 52;
    IconData icon = !isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignemt = isOpen ? Alignment.centerRight : Alignment.center;
    final margin = isOpen ? const EdgeInsets.only(right: 16) : null;
    final width = isOpen ? size : double.infinity;
    if (!isOpen) {
      return buildColapsedIcon(
        context,
        Icons.arrow_forward_ios,
        () => drawerMenuControllerProvider.toggleIsOpen(),
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // if (AuthProvider.isLoggedIn(context))
          const DrawerSettingButton(),
          // if (AuthProvider.isLoggedIn(context))
          CartIconWidget(
            returnNillIfZero: false,
            onPressed: () {
              context
                  .read<DrawerMenuControllerProvider>()
                  .controlEndDrawerMenu();
            },
          ),
          // if (AuthProvider.isLoggedIn(context))

          // oldCollapsedIcon(margin, alignemt, context, icon),
        ],
      ),
    ]);
  }
}

class DrawerHeaderLogo extends StatelessWidget {
  bool isOpen;
  DrawerHeaderLogo({
    super.key,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOpen) {
      return SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            // .add(safeArea),
            width: double.infinity,
            child: CompanyLogo()),
      );
    }
    return Card(
      color: Theme.of(context).colorScheme.outline.withOpacity(.1),
      elevation: 0,
      child: SafeArea(
        child: Container(
          // color: Theme.of(context).colorScheme.outline.withOpacity(.1),
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          // .add(safeArea),
          width: double.infinity,
          child: !isOpen
              ? CompanyLogo(
                  // size: 24,
                  )
              : HeaderLogo(),
        ),
      ),
    );
  }
}

class DrawerListTileDesktopOpen extends StatelessWidget {
  DrawerMenuItem item;
  DrawerListTileDesktopOpen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    DrawerMenuControllerProvider ds =
        context.watch<DrawerMenuControllerProvider>();

    bool isSelected = ds.getLastDrawerMenuItemClicked == item;

    if (SizeConfig.isDesktopOrWebPlatform(context)) {
      debugPrint("DrawerListTileDesktopOpen des");
      // return popMenuItem(context);
      Widget c = ListTile(
        leading: InkWell(
            onTap: () {
              item.onTapLeading?.call();
            },
            child: Icon(item.icon)),
        // selected: ds.getIndex == viewAbstract.hashCode,
        // title: ds.getSideMenuIsClosed
        //     ? null
        //     : Container(child: viewAbstract.getMainLabelText(context)),
        title: Text(item.title),
        onTap: () {
          context
              .read<DrawerMenuControllerProvider>()
              .setSideMenuIsClosed(byIdx: item);
          item.onTap?.call();
        },
      );
      if (isSelected) {
        debugPrint("DrawerListTileDesktopOpen des CardCorner");
        return CardCorner(
          key: UniqueKey(),
          color: Theme.of(context).highlightColor,
          // color: Theme.of(context).highlightColor,
          // borderSide: BorderSideColor.END,
          // elevation: 0,
          // color: Theme.of(context).colorScheme.primary,
          child: c,
        );
      }
      return c;

      //TODO not working any more for desktop return OnHoverWidget(
      //     scale: false,
      //     builder: (onHover) {
      //       return ListTile(
      //         leading: InkWell(
      //             onTap: () {
      //               viewAbstract.onDrawerLeadingItemClicked(context);
      //               debugPrint("onLeading ListTile tapped");
      //             },
      //             child: Container(
      //                 child: onHover
      //                     ? const Icon(Icons.plus_one_sharp)
      //                     : viewAbstract.getIcon())),
      //         selected: ds.getIndex == viewAbstract.hashCode,
      //         // title: ds.getSideMenuIsClosed
      //         //     ? null
      //         //     : Container(child: viewAbstract.getMainLabelText(context)),
      //         title: Container(child: viewAbstract.getMainLabelText(context)),
      //         onTap: () {
      //           debugPrint('onDrawerItemClicked=> $viewAbstract');
      //           context
      //               .read<DrawerMenuControllerProvider>()
      //               .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);
      //           viewAbstract.onDrawerItemClicked(context);
      //         },
      //       );
      //     });
    } else {
      debugPrint("DrawerListTileDesktopOpen s");
      return ListTile(
        leading: Icon(item.icon),
        selected: isSelected,
        title: Text(item.title),
        onTap: () {
          if (SizeConfig.isDesktopOrWebPlatform(context)) {
            context
                .read<DrawerMenuControllerProvider>()
                .setSideMenuIsClosed(byIdx: item);
          } else {
            context
                .read<DrawerMenuControllerProvider>()
                .controlStartDrawerMenu();
          }
          item.onTap?.call();
        },
      );
    }
  }

  Widget popMenuItem(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Row(
        children: <Widget>[
          Icon(
            item.icon,
            size: 15,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                item.title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTileDesktopClosed extends StatelessWidget {
  DrawerMenuItem item;
  DrawerListTileDesktopClosed({super.key, required this.item});
  Widget getSelectedWidget(BuildContext context, Widget c) {
    return Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.surface),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25), topLeft: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: c,
        ));
  }

  @override
  Widget build(BuildContext context) {
    DrawerMenuControllerProvider ds =
        context.watch<DrawerMenuControllerProvider>();
    bool isSelected = ds.getLastDrawerMenuItemClicked == item;

    Widget c = Column(children: [
      getIcon(ds, context),
      AnimatedScale(
        duration: const Duration(milliseconds: 700),
        scale: isSelected ? 1 : 0,
        child: Text(
          item.title,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);

    if (isSelected) {
      return getSelectedWidget(context, c);
    }
    return c;
  }

  IconButton getIcon(DrawerMenuControllerProvider ds, BuildContext context) {
    return IconButton(
        tooltip:
            isLargeScreenFromCurrentScreenSize(context) ? item.title : null,
        isSelected: ds.getLastDrawerMenuItemClicked == item,
        // iconSize: 20,
        // tooltip: viewAbstract.getMainHeaderLabelTextOnly(context),
        icon: Icon(
          item.icon,
          color: ds.getLastDrawerMenuItemClicked == item
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        onPressed: () {
          ds.setSideMenuIsClosed(byIdx: item);

          item.onTap?.call();
        });
  }
}
