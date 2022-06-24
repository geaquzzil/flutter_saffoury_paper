import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:provider/provider.dart';

import '../providers_controllers/drawer_selected_item_controler.dart';

class BaseSharedDrawer<T extends ViewAbstract> extends StatelessWidget {
  List<T> drawerItems;
  BaseSharedDrawer({Key? key, required this.drawerItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      child: Drawer(
        elevation: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterLogo(),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: drawerItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return DrawerListTile(
                      viewAbstract: drawerItems[index],
                      idx: index,
                    );
                  }),
            ),
            FlutterLogo()
          ],
        ),
      ),
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
    return ListTile(
      horizontalTitleGap: 0.0,
      // subtitle: viewAbstract.getLabelSubtitleText(context),
      leading: viewAbstract.getIcon(),
      selected:
          context.watch<DrawerMenuSelectedItemController>().getIndex == idx,
      title: viewAbstract.getLabelText(context),
      onTap: () {
        viewAbstract.onDrawerItemClicked(context);
        context.read<DrawerMenuSelectedItemController>().change(idx);
      },
    );
  }
}
