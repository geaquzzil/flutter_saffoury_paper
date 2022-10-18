import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:provider/provider.dart';

import '../../models/view_abstract_filterable.dart';
import '../../new_screens/home/components/ext_provider.dart';
import '../../providers/page_large_screens_provider.dart';
import '../edit_listeners/controller_dropbox_enum.dart';
import '../edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class SearchFilterableWidget extends StatelessWidget {
  ViewAbstract viewAbstract;
  SearchFilterableWidget({Key? key, required this.viewAbstract})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: [
        Expanded(
          child: Text(
              context
                  .watch<LargeScreenPageProvider>()
                  .getCurrentPageTitle(context),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: DropdownEnumControllerListener(
              viewAbstractEnum: SortByType.ASC,
              onSelected: (obj) {
                addFilterableSort(context, obj as SortByType);
                notifyListApi(context);
                debugPrint("SortByType is selected $obj");
              }),
        ),
        Expanded(
          child: DropdownStringListControllerListener(
              tag: "soso",
              hint: AppLocalizations.of(context)!.sortBy,
              list: viewAbstract.getMainFieldsIconsAndValues(context),
              onSelected: (obj) {
                debugPrint("is selected ${obj.runtimeType}");
                addFilterableSortField(
                    context, (obj as DropdownStringListItem).value.toString());
                notifyListApi(context);
                debugPrint("is selected $obj");
              }),
        ),
      ]),
    );
  }
}
