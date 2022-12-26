import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item.dart';
import 'package:flutter_view_controller/new_components/tow_pane_ext.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item.dart';
import 'package:flutter_view_controller/new_screens/filterables/base_filterable_main.dart';
import 'package:flutter_view_controller/new_screens/filterables/filterable_icon_widget.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_master_horizontal.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_multible_views.dart';
import 'package:flutter_view_controller/new_screens/lists/list_sticky_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/debouncer.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';

import '../lists/list_api_master.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  late DrawerViewAbstractListProvider drawerViewAbstractObsever;
  late Debouncer _debouncer;
  Widget? startPane;
  @override
  void initState() {
    super.initState();
    drawerViewAbstractObsever =
        Provider.of<DrawerViewAbstractListProvider>(context, listen: false);

    // _debouncer = Debouncer(
    //   milliseconds: 1000,
    // );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: ListTile(
        // tileColor: Colors.transparent,
        leading: const Icon(Icons.search),
        title: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (value) async {
            debugPrint("onSubmitted $value");
            await Configurations.saveQueryHistory(
                drawerViewAbstractObsever.getObject, value);
            // setState(() {});
          },
          controller: _controller,
          decoration: InputDecoration(
              fillColor: Colors.transparent,
              hintText: AppLocalizations.of(context)?.search,
              border: InputBorder.none),
          onChanged: onSearchTextChanged,
        ),
        trailing: getFilterWidget(context),
      ),
    );
  }

  Widget getFilterWidget(BuildContext context) {
    if (SizeConfig.isMobile(context)) {
      return IconButton(
        icon: Icon(Icons.filter_alt_rounded),
        onPressed: () async {
          showBottomSheetExt(
            context: context,
            builder: (p0) {
              return BaseFilterableMainWidget(
                useDraggableWidget: false,
              );
            },
          );
          // Navigator.pushNamed(context, "/search");
        },
      );
    }

    return FilterablePopupIconWidget();
  }

  Widget getSearchTraling() {
    // return FilterablePopupIconWidget();
    return IconButton(
      icon: const Icon(Icons.cancel),
      onPressed: () {
        _controller.clear();
        // setState(() {});
        // onSearchTextChanged('');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    startPane ??= getFirstPane(context);
    Widget endPane =
        _controller.text.isEmpty ? getEmptyWidget() : getSearchList();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        // // floatingActionButton: getBackFloatingActionButton(context),
        appBar: getAppBar(context),
        body: TowPaneExt(
          startPane: startPane!,
          endPane: endPane,
        ));
  }

  Widget getBody(BuildContext context) {
    // return Text("Dsad");
    return TowPaneExt(
      startPane: getFirstPane(context),
      endPane: getEmptyWidget(),
    );
  }

  Widget getFirstPane(BuildContext context) {
    Widget listStickyWidget = ListMultibleViews(
      // key: UniqueKey(),
      list: [
        // getSearchListItem(context),
        if (SizeConfig.isFoldable(context)) getFilterableListItem(context),
        getSuggestionListItem(context),
        getBasedOnYourSearchListItem(context),
        if (SizeConfig.isMobile(context)) getEmptyListStickyItem(),
      ],
    );
    if (SizeConfig.isFoldable(context)) return listStickyWidget;
    return _controller.text.isEmpty ? listStickyWidget : getSearchList();
  }

  Widget getSearchList() {
    return ListApiSearchableWidget(
      key: GlobalKey<ListApiMasterState>(),
      viewAbstract: drawerViewAbstractObsever.getObject.getSelfNewInstance()
        ..setCustomMapAsSearchable(_controller.text),
      buildFabs: false,
      buildSearchWidget: false,
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100,
      flexibleSpace: Hero(
          tag: "/search",
          child: Material(
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          spreadRadius: 2,
                          blurRadius: 10)
                    ]
                    // borderRadius: BorderRadius.only(
                    //     bottomRight: Radius.circular(15),
                    //     bottomLeft: Radius.circular(15)),
                    ),
                height: 100,
                // color: Theme.of(context).colorScheme.primary,
                child: SafeArea(child: _buildSearchBox(context))),
          )),
    );
  }

  // Widget oldAppBar(){

  // }

  ListStickyItem getEmptyListStickyItem() {
    return ListStickyItem(
      buildGroupNameInsideItemBuilder: false,
      groupItem: ListStickyGroupItem(groupName: ""),
      itemBuilder: (context) {
        return getEmptyWidget();
      },
    );
  }

  Widget getEmptyWidget() {
    return Center(
      child: EmptyWidget(
          lottiUrl:
              "https://assets1.lottiefiles.com/private_files/lf30_jo7huq2d.json"),
    );
  }

  ListStickyItem getBasedOnYourSearchListItem(BuildContext context) {
    return ListStickyItem(
        groupItem: ListStickyGroupItem(
            groupName: AppLocalizations.of(context)!.basedOnYourLastSearch,
            icon: Icons.search),
        itemBuilder: (context) => FutureBuilder<List<String>>(
              future: Configurations.loadListQuery(
                  drawerViewAbstractObsever.getObject),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return Text(AppLocalizations.of(context)!.noItems);
                  }
                  return SizedBox(
                      height: 200,
                      child: ListApiMasterHorizontal<List<AutoRest>>(
                          useOutLineCards: true,
                          object: snapshot.data!
                              .map((e) => AutoRest(
                                  obj: getNewInstance()
                                    ..setCustomMapAsSearchable(e),
                                  key: drawerViewAbstractObsever.getObject
                                      .getListableKeyWithoutCustomMap()))
                              .toList()));
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
  }

  ViewAbstract getNewInstance() {
    return drawerViewAbstractObsever.getObject.getSelfNewInstance();
  }

  ListStickyItem getSearchListItem(BuildContext context) {
    return ListStickyItem(
      buildGroupNameInsideItemBuilder: false,
      groupItem: ListStickyGroupItem(groupName: ""),
      itemBuilder: (context) {
        return Hero(
            tag: "/search",
            child: Material(child: Card(child: _buildSearchBox(context))));
      },
    );
  }

  ListStickyItem getFilterableListItem(BuildContext context) {
    return ListStickyItem(
        useExpansionTile: true,
        groupItem: ListStickyGroupItem(
            groupName: AppLocalizations.of(context)!.filter,
            icon: Icons.filter_alt),
        itemBuilder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: BaseFilterableMainWidget(
                setHeaderTitle: false,
                useDraggableWidget: false,
              ),
            ));
  }

  ListStickyItem getSuggestionListItem(BuildContext context) {
    return ListStickyItem(
        groupItem: ListStickyGroupItem(
            groupName: AppLocalizations.of(context)!.suggestionList,
            icon: Icons.info_outline),
        itemBuilder: (context) => FutureBuilder<List<String>>(
              future: Configurations.loadListQuery(
                  drawerViewAbstractObsever.getObject),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return Text(AppLocalizations.of(context)!.noItems);
                  }
                  return SizedBox(
                    height: 50,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        width: kDefaultPadding / 2,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var item = snapshot.data![index];
                        {
                          return ActionChip(
                            elevation: 1,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            shadowColor: Theme.of(context).colorScheme.shadow,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            avatar: Icon(Icons.search),
                            onPressed: () {
                              _controller.text = item;
                              onSearchTextChanged(item);
                            },
                            // deleteIcon: Icon(Icons.done),
                            label: Text(item),
                            // onDeleted: () {},
                          );
                        }
                      },
                      // ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ));
  }

  Widget getBackFloatingActionButton(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        child: Icon(Icons.arrow_back),
        onPressed: () => {Navigator.pop(context)});
  }

  Future<void> onSearchTextChanged(String value) async {
    if (value.isEmpty) return;

    // _debouncer.run(() async {
    //   await Configurations.saveQueryHistory(
    //       drawerViewAbstractObsever.getObject, value);
    //   setState(() {});
    // });
  }
}
