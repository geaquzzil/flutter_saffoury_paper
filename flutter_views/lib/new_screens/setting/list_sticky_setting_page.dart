import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/settings/printable_setting.dart';
import 'package:flutter_view_controller/new_components/scrollable_widget.dart';
import 'package:flutter_view_controller/providers/settings/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';


class ListStickySettingWidget extends StatelessWidget {
  const ListStickySettingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ModifiableInterface> modifieableList =
        context.read<SettingProvider>().getModifiableListSetting(context);
    // return Text("dsasdasda");
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: StickyGroupedListView<ModifiableInterface, String>(
        elements: modifieableList,
        order: StickyGroupedListOrder.ASC,
        groupBy: (ModifiableInterface element) =>
            element.getModifiableMainGroupName(context),
        groupComparator: (String value1, String value2) =>
            value2.compareTo(value1),
        itemComparator:
            (ModifiableInterface element1, ModifiableInterface element2) =>
                element1
                    .getModifibleTitleName(context)
                    .compareTo(element2.getModifibleTitleName(context)),
        floatingHeader: false,
        groupSeparatorBuilder: (element) =>_getGroupSeparator(context,element) ,
        itemBuilder: _getItem,
      ),
    );
  }

  Widget _getItem(BuildContext ctx, ModifiableInterface element) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Icon(element.getModifibleIconData()),
      title: Text(element.getModifibleTitleName(ctx)),
    );
  }

  Widget _getGroupSeparator(BuildContext ctx,ModifiableInterface element) {
    return Text(
      element.getModifiableMainGroupName(ctx).toString(),
      style: TextStyle(color: Colors.grey),
    );
  }

  //   Widget _getGroupSeparator(Element element) {
  //   return SizedBox(
  //     height: 50,
  //     child: Align(
  //       alignment: Alignment.center,
  //       child: Container(
  //         width: 120,
  //         decoration: BoxDecoration(
  //           color: Colors.blue[300],
  //           border: Border.all(
  //             color: Colors.blue[300]!,
  //           ),
  //           borderRadius: const BorderRadius.all(Radius.circular(20.0)),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             '${element.date.day}. ${element.date.month}, ${element.date.year}',
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _getItem(BuildContext ctx, Element element) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(6.0),
  //     ),
  //     elevation: 8.0,
  //     margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  //     child: SizedBox(
  //       child: ListTile(
  //         contentPadding:
  //             const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //         leading: Icon(element.icon),
  //         title: Text(element.name),
  //         trailing: Text('${element.date.hour}:00'),
  //       ),
  //     ),
  //   );
  // }
}

class Element {
  DateTime date;
  String name;
  IconData icon;

  Element(this.date, this.name, this.icon);
}
