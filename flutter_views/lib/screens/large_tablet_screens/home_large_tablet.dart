import 'package:flutter/material.dart';

import '../../models/view_abstract.dart';
import '../../widgets/responsive_size_layout/layouts_ext/side_menu.dart';

class HomeLargeTabletPage extends StatelessWidget {
  List<ViewAbstract> drawerItems;
  HomeLargeTabletPage({Key? key, required this.drawerItems}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        // Once our width is less then 1300 then it start showing errors
        // Now there is no error if our width is less then 1340
        Expanded(
          flex: size.width > 1340 ? 2 : 4,
          child: const SideMenu(),
        ),
        Expanded(
          flex: size.width > 1340 ? 3 : 5,
          child: const Center(
            child: Text("test page"),
          ),
        ),
        Expanded(
          flex: size.width > 1340 ? 8 : 10,
          child: const Center(
            child: Text("tes2t page"),
          ),
        ),
      ],
    );
  }
}
