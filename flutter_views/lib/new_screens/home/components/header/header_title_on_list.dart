import 'package:flutter/material.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/models/view_abstract_filterable.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_enum.dart';
import 'package:flutter_view_controller/new_components/edit_listeners/controller_dropbox_list.dart';
import 'package:flutter_view_controller/new_components/rounded_icon_button.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/home/components/ext_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/providers/page_large_screens_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HeaderTitleOnListMain extends StatefulWidget {
  const HeaderTitleOnListMain({Key? key}) : super(key: key);

  @override
  State<HeaderTitleOnListMain> createState() => _HeaderTitleMainState();
}

class _HeaderTitleMainState extends State<HeaderTitleOnListMain> {
  @override
  Widget build(BuildContext context) {
    ViewAbstract viewAbstract =
        context.watch<DrawerViewAbstractListProvider>().getObject;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                  context
                      .watch<LargeScreenPageProvider>()
                      .getCurrentPageTitle(context),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            // const Text('Craft beautiful UIs'),
            const Spacer(),
            RoundedIconButton(
                onTap: () {
                  debugPrint("is Clicked");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                          appBar: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            leading: IconButton(
                              color: Colors.black,
                              icon: const Icon(Icons.arrow_back_ios),
                              iconSize: 20.0,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            centerTitle: true,
                          ),
                          body: BaseFilterableMainWidget()),
                    ),
                  );
                  // BaseFilterableMainWidget();
                },
                icon: Icons.filter_alt_sharp),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownEnumControllerListener(
                    viewAbstractEnum: SortByType.ASC,
                    onSelected: (obj) {
                      addFilterableSort(context, obj as SortByType);
                      notifyListApi(context);
                      debugPrint("SortByType is selected $obj");
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownStringListControllerListener(
                    tag: "soso",
                    hint: AppLocalizations.of(context)!.sortBy,
                    list: viewAbstract.getMainFieldsIconsAndValues(context),
                    onSelected: (obj) {
                      debugPrint("is selected ${obj.runtimeType}");
                      addFilterableSortField(
                          context,
                          (obj as DropdownStringListItem).value.toString(),
                          obj.label);
                      notifyListApi(context);
                      debugPrint("is selected $obj");
                    }),
              ),
            ),
            // const Expanded(
            //   child: FittedBox(
            //     fit: BoxFit.contain, // otherwise the logo will be tiny
            //     child: FlutterLogo(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
