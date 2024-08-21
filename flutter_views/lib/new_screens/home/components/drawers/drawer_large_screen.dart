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

class DrawerLargeScreens extends StatefulWidget {
  CurrentScreenSize? size;
  DrawerLargeScreens({super.key, this.size});

  @override
  State<DrawerLargeScreens> createState() => _DrawerLargeScreensState();
}

class _DrawerLargeScreensState extends State<DrawerLargeScreens>
    with TickerProviderStateMixin {
  CurrentScreenSize? _size;
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
    super.initState();
    debugPrint("DrawerLargeScreens initState");
  }

  @override
  void didUpdateWidget(covariant DrawerLargeScreens oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    debugPrint("DrawerLargeScreens didUpdateWidget");
    _size = widget.size;
    if (canSmallDrawerWhenOpen()) {
      WidgetsBinding.instance.addPostFrameCallback((c) {
        if (drawerMenuControllerProvider.getSideMenuIsClosed) {
          drawerMenuControllerProvider.setSideMenuIsOpen();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    debugPrint("DrawerLargeScreens didChangeDependencies");
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
    return Selector<LayoutChangeListner, Tuple2<double?, double?>>(
      selector: (_, p) => Tuple2(p.getWidth, p.getHeight),
      builder: (_, v, ___) {
        debugPrint(
            "getBodyScaffold DrawerMenuController height ${v.item2} width ${v.item1}");
        if (v.item1 == null || v.item2 == null) return const SizedBox();
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceIn,
          width: showHamburger(_size)
              ? kDrawerOpenWidth
              : isOpen
                  ? kDrawerOpenWidth
                  : kDefaultClosedDrawer,
          height: v.item2,
          child: _getDrawerBodyScaffold(
              v, context, showHamburger(_size) ? true : isOpen),
        );
      },
    );
  }

  Widget _getDrawerBodyScaffold(
      Tuple2<double?, double?> v, BuildContext context, bool isOpen) {
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
          //  Expanded(child: buildProfilePic(context, isOpen)),
          // Expanded(
          //   child: PopupWidget(
          //       // position: PreferredPosition.bottom,
          //       child: Icon(Icons.settings_accessibility),
          //       menuBuilder: () => SizedBox(
          //           width: 700, height: 500, child: SettingAndProfileWeb())),
          // ),
          // if (!isOpen) const Expanded(child: DrawerSettingButton()),
          // Expanded(
          //   child: CartIconWidget(
          //     returnNillIfZero: false,
          //     onPressed: () {
          //       context
          //           .read<DrawerMenuControllerProvider>()
          //           .controlEndDrawerMenu();
          //     },
          //   ),
          // ),
          // if (AuthProvider.isLoggedIn(context))
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
    Widget c = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment:
          !isOpen ? MainAxisAlignment.center : MainAxisAlignment.end,
      children: [
        // const Divider(),
        // if (AuthProvider.isLoggedIn(context))
        Container(
            color: isOpen ? Theme.of(context).colorScheme.surface : null,
            child: buildProfilePic(context, isOpen)),

        if (!isOpen) const DrawerSettingButton(),
        if (isOpen)
          // if (AuthProvider.isLoggedIn(context))
          Container(
              color: isOpen ? Theme.of(context).colorScheme.surface : null,
              child: const Divider()),
        if (isOpen)
          Container(
              color: isOpen ? Theme.of(context).colorScheme.surface : null,
              child: buildCollapseIcon(context, isOpen)),
      ],
    );

    // if (isOpen) {
    //   return Center(
    //     child: c,
    //   );
    // }
    return c;
  }

  Widget buildHeader(BuildContext context, bool isOpen) {
    // return Icon(Icons.dangerous);
    // AnimatedSize(,)
    return Card(
      margin: EdgeInsets.zero,
      child: IconButton(
        // padding: EdgeInsets.all(kDefaultPadding),
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
    return Column(
      children: [
        ListTile(
          // title: DrawerHeaderLogo(isOpen: isOpen),
          title: const Icon(Icons.dangerous),
          leading: IconButton(
            onPressed: () {
              drawerMenuControllerProvider.toggleIsOpen();
              if (drawerMenuControllerProvider.getSideMenuIsOpen) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }
            },
            icon: AnimatedIcon(
                icon: AnimatedIcons.arrow_menu, progress: _animationController),
          ),
        ),
      ],
    );
    return DrawerHeaderLogo(
      isOpen: isOpen,
    );
  }

  List<Widget> buildListSlivers(BuildContext context, bool isOpen) {
    List<Widget> widgets = List.empty(growable: true);
    AuthProvider authProvider = Provider.of<AuthProvider<AuthUser>>(context);
    Map<String?, List<ViewAbstract<dynamic>>> l =
        authProvider.getDrawerItemsGrouped;
    for (var a in l.entries) {
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
                      a.key ?? "_",
                      style: Theme.of(context).textTheme.titleSmall,
                    )
                  : Divider(),
            ),
            buttonKey: buttonKey,
            child: Column(
              children: [
                for (int i = 0; i < a.value.length; i++)
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 600),
                    child: (isOpen)
                        ? DrawerListTileDesktopOpen(
                            viewAbstract: a.value[i],
                            idx: i,
                          )
                        : DrawerListTileDesktopClosed(
                            viewAbstract: a.value[i], idx: i),
                  )
              ],
            )),
        // SliverToBoxAdapter(child: getWidget(width, element))
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

class DrawerListTileDesktopGroupOpen extends StatelessWidget {
  List<ViewAbstract> groupedDrawerItems;
  int idx;

  DrawerListTileDesktopGroupOpen(
      {super.key, required this.groupedDrawerItems, required this.idx});

  @override
  Widget build(BuildContext context) {
    String? title = groupedDrawerItems[0].getMainDrawerGroupName(context);
    if (title == null) {
      // if (wrapeWithColumn) {}
      return ListView.builder(
          itemCount: groupedDrawerItems.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ViewAbstract viewAbstract = groupedDrawerItems[index];
            return DrawerListTileDesktopOpen(
                viewAbstract: viewAbstract, idx: index);
          });
    }
    return ListView.builder(
      itemCount: groupedDrawerItems.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        ViewAbstract viewAbstract = groupedDrawerItems[index];
        Widget currentWidget =
            DrawerListTileDesktopOpen(viewAbstract: viewAbstract, idx: index);
        if (index == groupedDrawerItems.length - 1) {
          return Column(
            children: [
              currentWidget,
              const Divider(),
            ],
          );
        } else {
          return currentWidget;
        }
      },
    );
    return ExpansionTile(
      title: Text(title),
      children: [
        ListView.builder(
            itemCount: groupedDrawerItems.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ViewAbstract viewAbstract = groupedDrawerItems[index];
              return DrawerListTileDesktopOpen(
                  viewAbstract: viewAbstract, idx: index);
            })
      ],
    );
  }
}

class DrawerListTile extends StatelessWidget {
  ViewAbstract viewAbstract;

  int idx;
  DrawerListTile({super.key, required this.viewAbstract, required this.idx});

  @override
  Widget build(BuildContext context) {
    return Selector<DrawerMenuControllerProvider, int>(
      builder: (context, value, child) {
        return ListTile(
          horizontalTitleGap: 0.0,
          // subtitle: viewAbstract.getLabelSubtitleText(context),
          leading: viewAbstract.getIcon(),
          selected: value == idx,
          title: viewAbstract.getMainLabelText(context),
          onTap: () {
            viewAbstract.onDrawerItemClicked(context);
            context.read<DrawerMenuControllerProvider>().changeDrawerIndex(idx);
          },
        );
      },
      selector: (p0, p1) => p1.getIndex,
    );
  }
}

class DrawerListTileDesktopOpen extends StatelessWidget {
  ViewAbstract viewAbstract;
  int idx;
  DrawerListTileDesktopOpen(
      {super.key, required this.viewAbstract, required this.idx});

  @override
  Widget build(BuildContext context) {
    DrawerMenuControllerProvider ds =
        context.watch<DrawerMenuControllerProvider>();

    if (SizeConfig.isDesktopOrWebPlatform(context)) {
      debugPrint("DrawerListTileDesktopOpen des");
      Widget c = ListTile(
        leading: InkWell(
            onTap: () {
              viewAbstract.onDrawerLeadingItemClicked(context);
              debugPrint("onLeading ListTile tapped");
            },
            child: Container(
                child: false
                    ? const Icon(Icons.plus_one_sharp)
                    : viewAbstract.getIcon())),
        // selected: ds.getIndex == viewAbstract.hashCode,
        // title: ds.getSideMenuIsClosed
        //     ? null
        //     : Container(child: viewAbstract.getMainLabelText(context)),
        title: Container(child: viewAbstract.getMainLabelText(context)),
        onTap: () {
          debugPrint('onDrawerItemClicked=> $viewAbstract');
          context
              .read<DrawerMenuControllerProvider>()
              .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);
          viewAbstract.onDrawerItemClicked(context);
        },
      );
      if (ds.getIndex == viewAbstract.hashCode) {
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
        leading: viewAbstract.getIcon(),
        selected: ds.getIndex == viewAbstract.hashCode,
        title: viewAbstract.getMainLabelText(context),
        onTap: () {
          if (SizeConfig.isDesktopOrWebPlatform(context)) {
            context
                .read<DrawerMenuControllerProvider>()
                .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);
          } else {
            context
                .read<DrawerMenuControllerProvider>()
                .controlStartDrawerMenu();
          }
          viewAbstract.onDrawerItemClicked(context);
        },
      );
    }
  }
}

class DrawerListTileDesktopClosed extends StatelessWidget {
  ViewAbstract viewAbstract;
  int idx;
  DrawerListTileDesktopClosed(
      {super.key, required this.viewAbstract, required this.idx});
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

    Widget c = Column(children: [
      getIcon(ds, context),
      // if (ds.getIndex == viewAbstract.hashCode)
      AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: ds.getIndex == viewAbstract.hashCode ? 1 : 0,
        child: Text(
          viewAbstract.getMainHeaderLabelTextOnly(context),
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);

    if (ds.getIndex == viewAbstract.hashCode) {
      return getSelectedWidget(context, c);
    }
    return c;
  }

  IconButton getIcon(DrawerMenuControllerProvider ds, BuildContext context) {
    return IconButton(
        isSelected: ds.getIndex == viewAbstract.hashCode,
        // iconSize: 20,
        // tooltip: viewAbstract.getMainHeaderLabelTextOnly(context),
        icon: Icon(
          viewAbstract.getMainIconData(),
          color: ds.getIndex == viewAbstract.hashCode
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
        onPressed: () {
          context
              .read<DrawerMenuControllerProvider>()
              .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);

          viewAbstract.onDrawerItemClicked(context);
        });
  }
}

class IsHoveredOnDrawerClosed with ChangeNotifier {
  bool isHovered = false;
  void setIsHovered(bool isHovered) {
    debugPrint("IsHoveredOnDrawerClosed isHovered=>$isHovered");
    if (this.isHovered == isHovered) return;
    this.isHovered = isHovered;
    notifyListeners();
    // notifyListeners();
  }
}
