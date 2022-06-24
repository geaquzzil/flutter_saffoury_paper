import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers_controllers/drawer_selected_item_controler.dart';
import 'package:flutter_view_controller/screens/base_shared_drawer.dart';
import 'package:flutter_view_controller/screens/on_hover_button.dart';
import 'package:provider/provider.dart';

class BaseSharedDrawerNew<T extends ViewAbstract> extends StatefulWidget {
  List<T> drawerItems;
  BaseSharedDrawerNew({Key? key, required this.drawerItems}) : super(key: key);

  @override
  State<BaseSharedDrawerNew> createState() => _BaseSharedDrawerNewState();
}

class _BaseSharedDrawerNewState extends State<BaseSharedDrawerNew> {
  bool sidebarOpen = false;
  double xOffset = 60;
  double yOffset = 0;
  void setSidebarState() {
    setState(() {
      xOffset = sidebarOpen ? 265 : 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      transform: Matrix4.translationValues(0, yOffset, 1),
      width: context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen
          ? 256
          : 60,
      height: double.infinity,
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Expanded(
                  child: ListView.builder(
                      itemCount: widget.drawerItems.length,
                      itemBuilder: ((context, index) => DrawerListTileDesktop(
                            viewAbstract: widget.drawerItems[index],
                            idx: index,
                          )))),
            ),
            BottomNavigationBarItem()
          ],
        ),
      ),
    );
    return Container(
      child: Stack(children: [
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Expanded(
                    child: ListView.builder(
                        itemCount: widget.drawerItems.length,
                        itemBuilder: ((context, index) => DrawerListTileDesktop(
                              viewAbstract: widget.drawerItems[index],
                              idx: index,
                            )))),
              ),
              BottomNavigationBarItem()
            ],
          ),
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 200),
          transform: Matrix4.translationValues(
              context
                      .watch<DrawerMenuSelectedItemController>()
                      .getSideMenuIsOpen
                  ? 256
                  : 60,
              yOffset,
              1),
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(child: Text('HomePage')),
        )
      ]),
    );
  }
}

class BottomNavigationBarItem extends StatelessWidget {
  const BottomNavigationBarItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOpen =
        context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen;
    if (isOpen) {
      return Container(
        color: Color(0xFFB1F2B36),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {}, icon: Icon(Icons.logout_outlined)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OnHoverWidget(builder: (onHover) {
                  return IconButton(
                    onPressed: () {},
                    color: onHover ? Colors.orange : Colors.white,
                    icon: Icon(Icons.info_outline),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      context
                          .read<DrawerMenuSelectedItemController>()
                          .setSideMenuIsClosed();
                    },
                    icon: Icon(Icons.arrow_back)),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: Color(0xFFB1F2B36),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                context
                    .read<DrawerMenuSelectedItemController>()
                    .setSideMenuIsOpen();
              },
              icon: Icon(Icons.arrow_forward)),
        ],
      ),
    );
  }
}

class SideItem extends StatelessWidget {
  final String itemText;

  GestureTapCallback onTap;
  SideItem({Key? key, required this.itemText, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Color(0xFFB1F2B36),
        child: Row(children: [
          Container(padding: EdgeInsets.all(20), child: Icon(Icons.abc)),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              itemText,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]),
      ),
    );
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