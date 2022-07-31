import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:provider/provider.dart';

class BaseFilterableMainWidget extends StatefulWidget {
  const BaseFilterableMainWidget({Key? key}) : super(key: key);

  @override
  State<BaseFilterableMainWidget> createState() =>
      _BaseFilterableMainWidgetState();
}

class _BaseFilterableMainWidgetState extends State<BaseFilterableMainWidget> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract drawerViewAbstract =
        context.watch<DrawerViewAbstractProvider>().getObject;

    return FutureBuilder(
        future: context
            .read<FilterableListApiProvider>()
            .getServerData(drawerViewAbstract),
        builder: ((context, snapshot) {
          return Text(snapshot.data.toString());
        }));
  }
}
