import 'package:flutter/material.dart';
import 'package:flutter_view_controller/interfaces/settings/ModifiableInterfaceAndPrintingSetting.dart';
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
        groupSeparatorBuilder: (element) =>
            _getGroupSeparator(context, element),
        itemBuilder: _getItem,
      ),
    );
  }

  Widget _getItem(BuildContext ctx, ModifiableInterface element) {
    return ListTile(
      // selectedTileColor: Colors.white,
      selected: ctx.watch<SettingProvider>().getSelectedObject?.hashCode ==
          element.hashCode,
      onTap: () {
        ctx.read<SettingProvider>().change(element);
      },
      // contentPadding:
      //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Icon(element.getModifibleIconData()),
      title: Text(element.getModifibleTitleName(ctx)),
    );
  }

  Widget _getGroupSeparator(BuildContext ctx, ModifiableInterface element) {
    return Text(
      element.getModifiableMainGroupName(ctx).toString(),
      style: Theme.of(ctx).textTheme.titleMedium!.copyWith(color: Colors.grey),
    );
  }
}
