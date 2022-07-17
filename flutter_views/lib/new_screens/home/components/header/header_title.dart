import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HeaderTitleMain extends StatefulWidget {
  const HeaderTitleMain({Key? key}) : super(key: key);

  @override
  State<HeaderTitleMain> createState() => _HeaderTitleMainState();
}

class _HeaderTitleMainState extends State<HeaderTitleMain> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.watch<DrawerViewAbstractProvider>().getObject;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Text(
                context
                    .watch<LargeScreenPageProvider>()
                    .getCurrentPageTitle(context),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const Text('Craft beautiful UIs'),
            const Spacer(),
            Expanded(
              child: DropdownEnumControllerListener(
                  viewAbstractEnum: SortByType.ASC,
                  onSelected: (obj) {
                    debugPrint("is selected $obj");
                  }),
            ),
            Expanded(
              child: DropdownStringListControllerListener(
                  tag: "soso",
                  hint: AppLocalizations.of(context)!.sortBy,
                  list: viewAbstract.getMainFieldsIconsAndValues(context),
                  onSelected: (obj) {
                    debugPrint("is selected $obj");
                  }),
            ),
            const Expanded(
              child: FittedBox(
                fit: BoxFit.contain, // otherwise the logo will be tiny
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
