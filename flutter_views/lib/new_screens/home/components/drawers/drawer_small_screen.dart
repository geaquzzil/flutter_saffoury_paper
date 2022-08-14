import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_selected_item_controler.dart';
import 'package:provider/provider.dart';

class DrawerMobile<T extends ViewAbstract> extends StatelessWidget {
  const DrawerMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Container(
      decoration: const BoxDecoration(
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: FlutterLogo(),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: authProvider.getDrawerItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return DrawerListTile(
                      viewAbstract: authProvider.getDrawerItems[index],
                      idx: index,
                    );
                  }),
            ),
            const FlutterLogo()
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
      title: viewAbstract.getMainLabelText(context),
      onTap: () {
        viewAbstract.onDrawerItemClicked(context);
        context.read<DrawerMenuSelectedItemController>().change(idx);
      },
    );
  }
}
