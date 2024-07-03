import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/cart/base_home_cart_screen.dart';
import 'package:flutter_view_controller/new_screens/filter_side.dart';
import 'package:flutter_view_controller/new_screens/home/components/drawers/drawer_large_screen.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';
import 'package:provider/provider.dart';

class BaseShared extends StatefulWidget {
  const BaseShared({super.key});

  @override
  State<BaseShared> createState() => _BaseSharedState();
}

class _BaseSharedState extends State<BaseShared> {
  bool lastStateIsSelectMood = false;
  late DrawerMenuControllerProvider drawerMenuControllerProvider;
  Widget? drawerWidget;
  Widget? navigationRailWidget;
  Widget? dashboardWidget;
  Widget? homeWidget;
  Widget? shopingWidget;
  late Widget customWidget;
  final _controller = SideMenuController();
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    drawerMenuControllerProvider = context.read<DrawerMenuControllerProvider>();
  }

  @override
  Widget build(BuildContext context) {
    // _controller.
    return Scaffold(
        key: drawerMenuControllerProvider.getStartDrawableKey,
        drawer: const DrawerLargeScreens(),
        // drawerScrimColor: Colors.transparent,
        // backgroundColor: compexDrawerCanvasColor,
        endDrawer: const BaseHomeCartPage(),
        // bottomNavigationBar: getBottomNavigationBar(),
        // appBar: getAppBar(),
        body: TowPaneExt(
          startPane: Row(
            children: [
              SideMenu(
                controller: _controller,
                // backgroundColor: Colors.blueGrey,
                mode: SideMenuMode.open,
                builder: (data) {
                  return SideMenuData(
                    header: const Text('Header'),
                    items: [
                      const SideMenuItemDataTitle(title: 'Section Header'),
                      SideMenuItemDataTile(
                        isSelected: _currentIndex == 0,
                        onTap: () => setState(() => _currentIndex = 0),
                        title: 'Item 1',
                        hoverColor: Colors.blue,
                        titleStyle: const TextStyle(color: Colors.white),
                        icon: const Icon(Icons.home_outlined),
                        selectedIcon: const Icon(Icons.home),
                        badgeBuilder: (w) => const Text(
                          '23',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SideMenuItemDataTile(
                        isSelected: _currentIndex == 1,
                        onTap: () => setState(() => _currentIndex = 1),
                        title: 'Item 2',
                        selectedTitleStyle: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.yellow),
                        icon: const Icon(Icons.table_bar_outlined),
                        selectedIcon: const Icon(Icons.table_bar),
                        titleStyle:
                            const TextStyle(color: Colors.deepPurpleAccent),
                      ),
                      const SideMenuItemDataTitle(
                        title: 'Account',
                        textAlign: TextAlign.center,
                      ),
                      SideMenuItemDataTile(
                        isSelected: _currentIndex == 2,
                        onTap: () => setState(() => _currentIndex = 2),
                        title: 'Item 3',
                        icon: const Icon(Icons.play_arrow),
                      ),
                      SideMenuItemDataTile(
                        isSelected: _currentIndex == 3,
                        onTap: () => setState(() => _currentIndex = 3),
                        title: 'Item 4',
                        icon: const Icon(Icons.car_crash),
                      ),
                    ],
                    footer: const Text('Footer'),
                  );
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'body',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _controller.toggle();
                      },
                      child: const Text('change side menu state'),
                    )
                  ],
                ),
              ),
              SideMenu(
                position: SideMenuPosition.right,
                builder: (data) => const SideMenuData(
                  customChild: FilterSide(),
                ),
              ),
            ],
          ),
          // endPane: Expanded(child: Card()),
        ));
  }
}
