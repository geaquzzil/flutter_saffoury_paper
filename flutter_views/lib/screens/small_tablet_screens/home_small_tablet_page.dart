import 'package:flutter/material.dart';

import '../../models/view_abstract.dart';

class HomeSmallTabletPage extends StatelessWidget {
  List<ViewAbstract> drawerItems;
  HomeSmallTabletPage({Key? key, required this.drawerItems}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: const [
      Expanded(
        flex: 6,
        child: Center(
          child: Text("test page"),
        ),
      ),
      Expanded(
        flex: 9,
        child: Center(
          child: Text("test page"),
        ),
      ),
    ]);
  }
}
