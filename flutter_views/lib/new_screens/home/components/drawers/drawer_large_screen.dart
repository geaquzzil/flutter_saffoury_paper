import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/popup_widget.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_corner.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/setting_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_header_list_tile_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_on_open_drawer.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/screens/web/components/header.dart';
import 'package:flutter_view_controller/screens/web/setting_and_profile.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../profile/profile_pic_popup_menu.dart';
import 'components/ext.dart';

class DrawerLargeScreens extends StatefulWidget {
  const DrawerLargeScreens({super.key});

  @override
  State<DrawerLargeScreens> createState() => _DrawerLargeScreensState();
}

class _DrawerLargeScreensState extends State<DrawerLargeScreens>
    with TickerProviderStateMixin {
  final padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding);

  late DrawerMenuControllerProvider drawerMenuControllerProvider;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _animationController.forward();
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DrawerMenuControllerProvider, bool>(
      builder: (__, isOpen, ___) {
        return getBody(isOpen, __);
      },
      selector: (p0, p1) => p1.getSideMenuIsOpen,
    );
  }

  Widget getBody(bool isOpen, BuildContext context) {
    return Selector<LayoutChangeListner, Tuple2<double?, double?>>(
      selector: (_, p) => Tuple2(p.getWidth, p.getHeight),
      builder: (_, v, ___) {
        debugPrint(
            "getBody DrawerMenuController height ${v.item2} width ${v.item1}");
        if (v.item1 == null || v.item2 == null) return SizedBox();
        return AnimatedSize(
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
          child: SizedBox(
            height: v.item2,
            // width: isOpen ? kDrawerOpenWidth : kDefaultClosedDrawer,
            child: Drawer(
              width: isOpen ? kDrawerOpenWidth : kDefaultClosedDrawer,
              child: _getDrawerBody(v, context, isOpen),
            ),
          ),
        );
      },
    );
  }

  Widget _getDrawerBody(
      Tuple2<double?, double?> v, BuildContext context, bool isOpen) {
    return Column(
      children: [
        // DrawerHeaderLogo(
        //   isOpen: isOpen,
        // ),
        SizedBox(
          height: (v.item2 ?? 1000) * .25,
          child: buildHeader(context, isOpen),
        ),
        // FloatingActionButton(
        //     onPressed: () => {}, child: Icon(Icons.edit)),
        SizedBox(
          height: !isOpen
              ? (v.item2 ?? 1000) * .5
              : v.item2.toNonNullable() - (100 + (v.item2 ?? 1000) * .25),
          child: CustomScrollView(
            slivers: [
              // SliverToBoxAdapter(child: buildHeader(context, isOpen)),
              // buildList(context, isOpen),
              buildListSliver(context, isOpen)
            ],
          ),
        ),

        // const Divider(height: 2),
        SizedBox(
            height: !isOpen ? ((v.item2 ?? 1000) * .25) : 100,
            child: buildDrawerFooter(context, isOpen)),
        // NotificationPopupWidget()
        // Column(mainAxisAlignment: MainAxisAlignment.start, children: [

        //   // const Spacer(),
        // ]),

        // buildProfilePic(context, isOpen),
      ],
    );
  }

  Widget buildDrawerFooter(BuildContext context, bool isOpen) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Flex(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisAlignment:
        //     !isOpen ? MainAxisAlignment.center : MainAxisAlignment.end,
        direction: isOpen ? Axis.horizontal : Axis.vertical,
        children: [
          //  Expanded(child: buildProfilePic(context, isOpen)),
          PopupWidget(
              // position: PreferredPosition.bottom,
              child: Icon(Icons.settings_accessibility),
              menuBuilder: () => SizedBox(
                  width: 700, height: 500, child: SettingAndProfileWeb())),
          if (!isOpen) const Expanded(child: DrawerSettingButton()),
          Expanded(
            child: CartIconWidget(
              returnNillIfZero: false,
              onPressed: () {
                context
                    .read<DrawerMenuControllerProvider>()
                    .controlEndDrawerMenu();
              },
            ),
          ),
          // if (AuthProvider.isLoggedIn(context))
          NotificationPopupWidget(),
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
            color: isOpen ? Theme.of(context).colorScheme.background : null,
            child: buildProfilePic(context, isOpen)),

        if (!isOpen) const DrawerSettingButton(),
        if (isOpen)
          // if (AuthProvider.isLoggedIn(context))
          Container(
              color: isOpen ? Theme.of(context).colorScheme.background : null,
              child: const Divider()),
        if (isOpen)
          Container(
              color: isOpen ? Theme.of(context).colorScheme.background : null,
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
    return IconButton(
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

  Widget buildListSliver(BuildContext context, bool isOpen) {
    AuthProvider authProvider = Provider.of<AuthProvider<AuthUser>>(context);
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) =>
                buildSubList(context, index, isOpen, authProvider),
            childCount: authProvider.getDrawerItemsGrouped.length));
  }

  Widget buildList(BuildContext context, bool isOpen) {
    AuthProvider authProvider = Provider.of<AuthProvider<AuthUser>>(context);
    return ListView.builder(
        itemCount: authProvider.getDrawerItemsGrouped.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return buildSubList(context, index, isOpen, authProvider);
        });
  }

  Widget buildSubList(
      BuildContext context, int index, bool isOpen, AuthProvider authProvider) {
    bool isClosed = !isOpen;
    String? groupLabel =
        authProvider.getDrawerItemsGrouped.keys.elementAt(index);

    debugPrint(
        "getDrawerItemsGrouped current index=> $index groupLabel=> $groupLabel count of group items => ${authProvider.getDrawerItemsGrouped[groupLabel]?.length}");
    if (groupLabel != null) {
      return isOpen
          ? DrawerListTileDesktopGroupOpen(
              groupedDrawerItems:
                  authProvider.getDrawerItemsGrouped[groupLabel] ?? [],
              idx: index)
          : DrawerListTileDesktopGroupClosed(
              groupedDrawerItems:
                  authProvider.getDrawerItemsGrouped[groupLabel] ?? [],
              idx: index,
            );
    } else if (authProvider.getDrawerItemsGrouped[groupLabel]!.length > 1 &&
        groupLabel == null) {
      return isOpen
          ? DrawerListTileDesktopGroupOpen(
              groupedDrawerItems:
                  authProvider.getDrawerItemsGrouped[groupLabel] ?? [],
              idx: index)
          : DrawerListTileDesktopGroupClosed(
              groupedDrawerItems:
                  authProvider.getDrawerItemsGrouped[groupLabel] ?? [],
              idx: index,
            );
    }
    ViewAbstract viewAbstract =
        authProvider.getDrawerItemsGrouped[groupLabel]![index];
    return DrawerListTileDesktopOpen(viewAbstract: viewAbstract, idx: index);
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
          NotificationPopupWidget(),
          const DrawerLanguageButton(),

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
      {Key? key, required this.groupedDrawerItems, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? title = groupedDrawerItems[0].getMainDrawerGroupName(context);
    if (title == null) {
      return ListView.builder(
          itemCount: groupedDrawerItems.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ViewAbstract viewAbstract = groupedDrawerItems[index];
            return DrawerListTileDesktopOpen(
                viewAbstract: viewAbstract, idx: index);
          });
    }
    // return Column(
    //   children: [
    //     Divider(),
    //     ListView.builder(
    //         itemCount: groupedDrawerItems.length,
    //         shrinkWrap: true,
    //         itemBuilder: (context, index) {
    //           ViewAbstract viewAbstract = groupedDrawerItems[index];
    //           return DrawerListTileDesktopOpen(
    //               viewAbstract: viewAbstract, idx: index);
    //         })
    //   ],
    // );

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
  DrawerListTile({Key? key, required this.viewAbstract, required this.idx})
      : super(key: key);

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

@immutable
class DrawerListTileDesktopGroupClosed extends StatefulWidget {
  List<ViewAbstract> groupedDrawerItems;
  int idx;
  DrawerListTileDesktopGroupClosed(
      {Key? key, required this.groupedDrawerItems, required this.idx})
      : super(key: key);

  @override
  State<DrawerListTileDesktopGroupClosed> createState() =>
      _DrawerListTileDesktopGroupClosedState();
}

class _DrawerListTileDesktopGroupClosedState
    extends State<DrawerListTileDesktopGroupClosed> {
  Widget listItems(BuildContext context) {
    return ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: kDefaultPadding / 2,
          );
        },
        itemCount: widget.groupedDrawerItems.length,
        shrinkWrap: true,
        primary: true,
        itemBuilder: (context, index) {
          ViewAbstract viewAbstract = widget.groupedDrawerItems[index];

          Widget currentWidget = DrawerListTileDesktopClosed(
              viewAbstract: viewAbstract, idx: index);
          if (index == widget.groupedDrawerItems.length - 1) {
            return Column(
              children: [
                currentWidget,
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Divider(),
                )
              ],
            );
          }
          return currentWidget;
        });
  }

  @override
  Widget build(BuildContext context) {
    return listItems(context);
    return OnHoverWidget(builder: (isHovered) {
      if (!isHovered) {
        return SizedBox(
            width: 40,
            height: 40,
            child: Selector<DrawerMenuControllerProvider, int>(
              builder: (context, value, child) => Icon(
                widget.groupedDrawerItems[0].getMainDrawerGroupIconData() ??
                    Icons.abc,
                color: widget.groupedDrawerItems.firstWhereOrNull(
                            (element) => element.hashCode == value) !=
                        null
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              selector: (p0, p1) => p1.getIndex,
            ));
      } else {
        return listItems(context);
      }
    });
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
      {Key? key, required this.viewAbstract, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DrawerMenuControllerProvider ds =
        context.watch<DrawerMenuControllerProvider>();
    return Column(children: [
      IconButton(
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
          }),
      // if (ds.getIndex == viewAbstract.hashCode)
      AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: ds.getIndex == viewAbstract.hashCode ? 1 : 0,
        child: Text(
          viewAbstract.getMainHeaderLabelTextOnly(context),
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);

    return OnHoverWidget(
        scale: false,
        builder: (onHover) {
          return IconButton(

              // tooltip: viewAbstract.getMainHeaderLabelTextOnly(context),

              icon: Icon(
                viewAbstract.getMainIconData(),
                color: onHover
                    ? Theme.of(context).colorScheme.primary
                    : ds.getIndex == viewAbstract.hashCode
                        ? Theme.of(context).colorScheme.primary
                        : null,
              ),
              onPressed: () {
                context
                    .read<DrawerMenuControllerProvider>()
                    .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);

                viewAbstract.onDrawerItemClicked(context);
              });
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
