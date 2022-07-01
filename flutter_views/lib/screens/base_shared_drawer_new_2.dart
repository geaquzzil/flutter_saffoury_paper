import 'package:flutter/material.dart';
import 'package:flutter_view_controller/flutter_view_controller.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_selected_item_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_new.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  List<String> _addedGroups = [];
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return SizedBox(
      width: context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen
          ? null
          : 60,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Container(
          color: const Color(0xFF1A2F45),
          child: Column(children: [
            Container(
                color: Colors.white12,
                padding: const EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                child: buildHeader(context)),
            buildList(context),
            const Spacer(),
            buildCollapseIcon(context),
            const SizedBox(
              height: 12,
            )
          ]),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return !context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen
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
          );
  }

  Widget buildList(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    bool isClosed =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsClosed;
    return ListView.separated(
        padding: isClosed ? EdgeInsets.zero : padding,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: authProvider.getDrawerItems.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          ViewAbstract viewAbstract = authProvider.getDrawerItems[index];
          String? groupLabel = viewAbstract.getDrawerGroupName();

          if (groupLabel != null ) {
            _addedGroups.add(groupLabel);
            List<ViewAbstract> groupedDrawerItems = authProvider.getDrawerItems
                .where((e) =>
                    e.getDrawerGroupName() == viewAbstract.getDrawerGroupName())
                .toList();
            return DrawerListTileDesktopGroup(
                groupedDrawerItems: groupedDrawerItems, idx: index);
          }
          return DrawerListTileDesktop(viewAbstract: viewAbstract, idx: index);
        });
  }

  Widget buildCollapseIcon(BuildContext context) {
    const double size = 52;
    bool isOpen =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen;
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
            child: OnHoverWidget(builder: (onHover) {
              return Icon(
                icon,
                color: onHover ? Colors.orange : Colors.white,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class DrawerListTileDesktopGroup extends StatelessWidget {
  List<ViewAbstract> groupedDrawerItems;
  int idx;
  DrawerListTileDesktopGroup(
      {Key? key, required this.groupedDrawerItems, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOpen =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen;
    bool isClosed =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsClosed;
    String title = groupedDrawerItems[0].getDrawerGroupName() ?? "";
    return isOpen
        ? ExpansionTile(
            title: Text(title),
            children: [
              ListView.separated(
                  padding: isClosed
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(horizontal: 20),
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
                    return DrawerListTileDesktop(
                        viewAbstract: viewAbstract, idx: index);
                  })
            ],
          )
        : Text("TODO");
  }
}

class DrawerListTileDesktop extends StatelessWidget {
  ViewAbstract viewAbstract;

  int idx;
  DrawerListTileDesktop(
      {Key? key, required this.viewAbstract, required this.idx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(child: viewAbstract.getIcon()),
        selected:
            context.watch<DrawerMenuSelectedItemController>().getIndex == idx,
        title: context
                .watch<DrawerMenuSelectedItemController>()
                .getSideMenuIsClosed
            ? null
            : Container(child: viewAbstract.getLabelText(context)),
        onTap: () {
          context
              .read<DrawerMenuSelectedItemController>()
              .setSideMenuIsClosed();
          viewAbstract.onDrawerItemClicked(context);
          context.read<DrawerMenuSelectedItemController>().change(idx);
        },
      ),
    );
  }
}
