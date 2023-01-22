import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/ext_utils.dart';
import 'package:flutter_view_controller/models/permissions/user_auth.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/outline_card.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
import 'package:flutter_view_controller/new_components/company_logo.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list_icon.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/language_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/components/setting_button.dart';
import 'package:flutter_view_controller/new_screens/home/components/notifications/notification_popup.dart';
import 'package:flutter_view_controller/new_screens/home/components/profile/profile_on_open_drawer.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:flutter_view_controller/providers/settings/language_provider.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cart/cart_provider.dart';
import '../profile/profile_pic_popup_menu.dart';
import 'components/ext.dart';

class DrawerLargeScreens extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: kDefaultPadding);

  late DrawerMenuControllerProvider drawerMenuControllerProvider;

  @override
  Widget build(BuildContext context) {
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
    // return getBody(false, context);
    // bool isHovered = context.watch<IsHoveredOnDrawerClosed>().isHovered;
    return Selector<DrawerMenuControllerProvider, bool>(
      builder: (__, isOpen, ___) {
        return getBody(isOpen, __);
      },
      selector: (p0, p1) => p1.getSideMenuIsOpen,
    );
  }

  AnimatedSize getBody(bool isOpen, BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      child: SizedBox(
        height: double.maxFinite,
        width: isOpen ? SizeConfig.getDrawerWidth(context) : 60,
        // color: Colors.blueGrey,
        child: Card(
          child: Stack(
            alignment: Alignment.bottomCenter,
            fit: StackFit.loose,
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: buildHeader(context, isOpen)),
                  // buildList(context, isOpen),
                  buildListSliver(context, isOpen)
                ],
              ),
              // Column(mainAxisAlignment: MainAxisAlignment.start, children: [

              //   // const Spacer(),
              // ]),

              buildDrawerFooter(context, isOpen),
              // buildProfilePic(context, isOpen),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerFooter(BuildContext context, bool isOpen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const Divider(),
        Container(
            color: isOpen ? Theme.of(context).colorScheme.background : null,
            child: buildProfilePic(context, isOpen)),
        Container(
            color: isOpen ? Theme.of(context).colorScheme.background : null,
            child: const Divider()),
        Container(
            color: isOpen ? Theme.of(context).colorScheme.background : null,
            child: buildCollapseIcon(context, isOpen)),
      ],
    );
  }

  Widget buildHeader(BuildContext context, bool isOpen) {
    // AnimatedSize(,)
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
    }
    ViewAbstract viewAbstract =
        authProvider.getDrawerItemsGrouped[groupLabel]!.first;
    return DrawerListTileDesktopOpen(viewAbstract: viewAbstract, idx: index);
  }

  Widget buildProfilePic(BuildContext context, bool isOpen) {
    const double size = 52;
    IconData icon = !isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignemt = isOpen ? Alignment.centerRight : Alignment.center;
    final margin = isOpen ? const EdgeInsets.only(right: 16) : null;
    final width = isOpen ? size : double.infinity;
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
          const DrawerSettingButton(),
          CartIconWidget(
            returnNillIfZero: false,
            onPressed: () {
              context
                  .read<DrawerMenuControllerProvider>()
                  .controlEndDrawerMenu();
            },
          ),

          NotificationPopupWidget(),
          const DrawerLanguageButton(),
          if (SizeConfig.isDesktopOrWeb(context))
            buildColapsedIcon(
              context,
              Icons.arrow_back_ios,
              () => drawerMenuControllerProvider.toggleIsOpen(),
            ),

          // oldCollapsedIcon(margin, alignemt, context, icon),
        ],
      ),
    ]);
  }
}

class DrawerHeaderLogo extends StatelessWidget {
  bool isOpen;
  DrawerHeaderLogo({
    Key? key,
    required this.isOpen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                ? CompanyLogo()
                : Row(
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      CompanyLogo(),
                      const SizedBox(
                        width: 16,
                      ),
                      const Text("SaffouryPaper")
                    ],
                  )),
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
    String title = groupedDrawerItems[0].getMainDrawerGroupName(context) ?? "";
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
    return OutlinedCard(
      child: ListView.separated(
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
            return DrawerListTileDesktopClosed(
                viewAbstract: viewAbstract, idx: index);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      {Key? key, required this.viewAbstract, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DrawerMenuControllerProvider ds =
        context.watch<DrawerMenuControllerProvider>();

    if (SizeConfig.isDesktopOrWeb(context)) {
      return OnHoverWidget(
          scale: false,
          builder: (onHover) {
            return Material(
              color: Colors.transparent,
              child: ListTile(
                leading: InkWell(
                    onTap: () {
                      viewAbstract.onDrawerLeadingItemClicked(context);
                      debugPrint("onLeading ListTile tapped");
                    },
                    child: Container(
                        child: onHover
                            ? const Icon(Icons.plus_one_sharp)
                            : viewAbstract.getIcon())),
                selected: ds.getIndex == viewAbstract.hashCode,
                title: ds.getSideMenuIsClosed
                    ? null
                    : Container(child: viewAbstract.getMainLabelText(context)),
                onTap: () {
                  if (SizeConfig.isDesktopOrWeb(context)) {
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
              ),
            );
          });
    } else {
      return ListTile(
        leading: viewAbstract.getIcon(),
        selected: ds.getIndex == viewAbstract.hashCode,
        title: viewAbstract.getMainLabelText(context),
        onTap: () {
          if (SizeConfig.isDesktopOrWeb(context)) {
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
