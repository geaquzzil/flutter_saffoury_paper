import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/servers/server_data.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/filterables/custom_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/filterables/master_list_filterable.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/providers/filterables/fliterable_list_provider_api.dart';
import 'package:lottie/lottie.dart';
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
            .read<FilterableListApiProvider<FilterableData>>()
            .getServerData(drawerViewAbstract),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getListFilterableControlers(context, drawerViewAbstract);
          }
          return Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_mr1olA.json");
        }));
  }

  Widget getListFilterableControlers(
      BuildContext context, ViewAbstract drawerViewAbstract) {
    Map<ViewAbstract, List<dynamic>> list = context
        .read<FilterableListApiProvider<FilterableData>>()
        .getRequiredFiltter;

    return ListView(
      children: [
        ListView.builder(
          // separatorBuilder: (context, index) {
          //   return const Divider();
          // },
          itemCount: list.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            ViewAbstract viewAbstract = list.keys.elementAt(index);
            List<dynamic> itemsViewAbstract = list[viewAbstract] ?? [];
            debugPrint(
                "getListFilterableControlers is => ${viewAbstract.runtimeType.toString()} count is ${itemsViewAbstract.length}");
            return MasterFilterableController(
                viewAbstract: viewAbstract, list: itemsViewAbstract);
          },
        ),
        ListView.builder(
            itemCount:
                drawerViewAbstract.getCustomFilterableFields(context).length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return CustomFilterableController(
                  customFilterableField: drawerViewAbstract
                      .getCustomFilterableFields(context)[index]);
            }),
        TextButton(
          child: const Text("DONE"),
          onPressed: () {
            notifyListApi(context);
            Navigator.pop(context);
            // debugPrint(context.read<FilterableProvider>().getList.toString());
          },
        )
      ],
    );
  }
}
