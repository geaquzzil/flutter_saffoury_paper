import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_selected_item_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer_new.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);

  List<ViewAbstract> drawerItems;
  NavigationDrawerWidget({Key? key, required this.drawerItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return Container(
      width: context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen
          ? null
          : 60,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Container(
          color: Color(0xFF1A2F45),
          child: Column(children: [
            Container(
                color: Colors.white12,
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                child: buildHeader(context)),
            buildList(context),
            Spacer(),
            buildCollapseIcon(context),
            SizedBox(
              height: 12,
            )
          ]),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return !context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen
        ? FlutterLogo(
            size: 48,
          )
        : Row(
            children: [
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
    bool isClosed =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsClosed;
    return ListView.separated(
        padding: isClosed ? EdgeInsets.zero : padding,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 16,
          );
        },
        itemCount: drawerItems.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return DrawerListTileDesktop(
              viewAbstract: drawerItems[index], idx: index);
        });
  }

  Widget buildCollapseIcon(BuildContext context) {
    final double size = 52;
    bool isOpen =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen;
    IconData icon = !isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignemt = isOpen ? Alignment.centerRight : Alignment.center;
    final margin = isOpen ? EdgeInsets.only(right: 16) : null;
    final width = isOpen ? size : double.infinity;
    return Container(
      margin: margin,
      alignment: alignemt,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () =>
              context.read<DrawerMenuSelectedItemController>().toggleIsOpen(),
          child: Container(
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
