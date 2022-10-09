import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/shadow_widget.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_selected_item_controler.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';

import 'package:provider/provider.dart';
import 'package:flutter_view_controller/ext_utils.dart';

class DrawerLargeScreens extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    bool isOpen =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen;

    // bool isHovered = context.watch<IsHoveredOnDrawerClosed>().isHovered;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        height: double.maxFinite,
        width: isOpen ? 256 : 60,
        color: Colors.white,
        child: Column(children: [
          buildHeader(context, isOpen),
          buildList(context, isOpen),
          const Spacer(),
          buildCollapseIcon(context, isOpen),
          const SizedBox(
            height: 12,
          )
        ]),
      ),
    );
  }

  Widget buildHeader(BuildContext context, bool isOpen) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    // AnimatedSize(,)
    return Container(
        color: Colors.white12,
        padding: const EdgeInsets.symmetric(vertical: 24).add(safeArea),
        width: double.infinity,
        child: !isOpen
            ? const FlutterLogo(
                size: 48,
              )
            : Row(
                children: const [
                  SizedBox(
                    width: 24,
                  ),
                  FlutterLogo(
                    size: 48,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text("Flutter")
                ],
              ));
  }

  Widget buildList(BuildContext context, bool isOpen) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    bool isClosed = !isOpen;
    debugPrint(
        "getDrawerItemsGrouped current length=> ${authProvider.getDrawerItemsGrouped.length}");
    debugPrint(
        "getDrawerItemsGrouped current entires length=> ${authProvider.getDrawerItemsGrouped.entries.length}");
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: isClosed ? EdgeInsets.zero : padding,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: authProvider.getDrawerItemsGrouped.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
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
          return DrawerListTileDesktopOpen(
              viewAbstract: viewAbstract, idx: index);
        });
  }

  Widget buildCollapseIcon(BuildContext context, bool isOpen) {
    const double size = 52;
    IconData icon = !isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignemt = isOpen ? Alignment.centerRight : Alignment.center;
    final margin = isOpen ? const EdgeInsets.only(right: 16) : null;
    final width = isOpen ? size : double.infinity;
    return Container(
      margin: margin,
      alignment: alignemt,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              context.read<DrawerMenuSelectedItemController>().toggleIsOpen(),
          child: SizedBox(
            width: width,
            height: size,
            child: OnHoverWidget(
                scale: false,
                builder: (onHover) {
                  return Icon(
                    icon,
                    color: onHover ? Colors.orange : Colors.black,
                  );
                }),
          ),
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
    String title = groupedDrawerItems[0].getMainDrawerGroupName(context) ?? "";
    return ExpansionTile(
      title: Text(title),
      children: [
        ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: groupedDrawerItems.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              ViewAbstract viewAbstract = groupedDrawerItems[index];
              return DrawerListTileDesktopOpen(
                  viewAbstract: viewAbstract, idx: index);
            })
      ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: ShadowWidget(
        child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: widget.groupedDrawerItems.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              ViewAbstract viewAbstract = widget.groupedDrawerItems[index];
              return DrawerListTileDesktopClosed(
                  viewAbstract: viewAbstract, idx: index);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DrawerMenuSelectedItemController ds =
        context.watch<DrawerMenuSelectedItemController>();
    return OnHoverWidget(builder: (isHovered) {
      // context.read<IsHoveredOnDrawerClosed>().setIsHovered(isHovered);
      // return Icon(widget.groupedDrawerItems[0].getMainDrawerGroupIconData() ??
      //     Icons.abc);
      if (!isHovered) {
        return SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            widget.groupedDrawerItems[0].getMainDrawerGroupIconData() ??
                Icons.abc,
            color: widget.groupedDrawerItems.firstWhereOrNull(
                        (element) => element.hashCode == ds.getIndex) !=
                    null
                ? Colors.orange
                : null,
          ),
        );
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
    DrawerMenuSelectedItemController ds =
        context.watch<DrawerMenuSelectedItemController>();
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
                context
                    .read<DrawerMenuSelectedItemController>()
                    .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);
                viewAbstract.onDrawerItemClicked(context);
              },
            ),
          );
        });
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
    DrawerMenuSelectedItemController ds =
        context.watch<DrawerMenuSelectedItemController>();
    return OnHoverWidget(
        scale: false,
        builder: (onHover) {
          return Material(
              color: Colors.transparent,
              child: IconButton(

                  // tooltip: viewAbstract.getMainHeaderLabelTextOnly(context),

                  icon: Icon(
                    viewAbstract.getMainIconData(),
                    color: ds.getIndex == viewAbstract.hashCode
                        ? Colors.orange
                        : null,
                  ),
                  onPressed: () {
                    context
                        .read<DrawerMenuSelectedItemController>()
                        .setSideMenuIsClosed(byIdx: viewAbstract.hashCode);

                    viewAbstract.onDrawerItemClicked(context);
                  }));
        });

    //     ListTile(
    //       leading: InkWell(
    //           onTap: () {
    //             viewAbstract.onDrawerLeadingItemClicked(context);
    //             debugPrint("onLeading ListTile tapped");
    //           },
    //           child: Container(
    //               child: onHover
    //                   ? const Icon(Icons.plus_one_sharp)
    //                   : viewAbstract.getIcon())),
    //       selected: ds.getIndex == idx,
    //       title: ds.getSideMenuIsClosed
    //           ? null
    //           : Container(child: viewAbstract.getMainLabelText(context)),
    //       onTap: () {
    //         context
    //             .read<DrawerMenuSelectedItemController>()
    //             .setSideMenuIsClosed(byIdx: idx);
    //         viewAbstract.onDrawerItemClicked(context);
    //       },
    //     ),
    //   );
    // });
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
