import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawer_large/drawer_large_screen.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_selected_item_controler.dart';
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
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(0, yOffset, 1),
      width: context.watch<DrawerMenuSelectedItemController>().getSideMenuIsOpen
          ? 256
          : 60,
      height: double.infinity,
      child: SizedBox(
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
            const BottomNavigationBarItem()
          ],
        ),
      ),
    );
    return Container(
      child: Stack(children: [
        SizedBox(
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
              const BottomNavigationBarItem()
            ],
          ),
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
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
          child: const Center(child: Text('HomePage')),
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
        color: const Color(0xffb1f2b36),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.logout_outlined)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OnHoverWidget(builder: (onHover) {
                  return IconButton(
                    onPressed: () {},
                    color: onHover ? Colors.orange : Colors.white,
                    icon: const Icon(Icons.info_outline),
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
                    icon: const Icon(Icons.arrow_back)),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      color: const Color(0xffb1f2b36),
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
              icon: const Icon(Icons.arrow_forward)),
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
        color: const Color(0xffb1f2b36),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(20), child: const Icon(Icons.abc)),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              itemText,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ]),
      ),
    );
  }
}



