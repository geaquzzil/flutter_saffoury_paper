import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_screens/dashboard2/components/chart_card_item.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_api_searchable_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/list_sticky_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_viewabstract_list.dart';
import 'package:flutter_view_controller/utils/debouncer.dart';
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
  @override
  void initState() {
    super.initState();
    drawerViewAbstractObsever =
        Provider.of<DrawerViewAbstractListProvider>(context, listen: false);

    _debouncer = Debouncer(
      milliseconds: 1000,
    );
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding / 2),
      child: ListTile(
        leading: const Icon(Icons.search),
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
              hintText: AppLocalizations.of(context)?.search,
              border: InputBorder.none),
          onChanged: onSearchTextChanged,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            _controller.clear();
            onSearchTextChanged('');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: getBackFloatingActionButton(context),
        body: Column(
          children: [
            Hero(
                tag: "/search",
                child: Material(
                  child: Card(
                      // height: 100,
                      // color: Theme.of(context).colorScheme.primary,
                      child: SafeArea(
                          child: Row(children: [
                    BackButton(),
                    Expanded(child: _buildSearchBox(context))
                  ]))),
                )),

            _controller.text.isEmpty
                ? Expanded(
                    child: ListStickyWidget(
                      list: [
                        getSuggestionListItem(context),
                        getBasedOnYourSearchListItem(context),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListApiSearchableWidget(
                      key: GlobalKey<ListApiMasterState>(),
                      viewAbstract: drawerViewAbstractObsever.getObject
                          .getSelfNewInstance()
                        ..setCustomMapAsSearchable(_controller.text),
                      buildFabs: false,
                      buildSearchWidget: false,
                    ),
                  ),
            Expanded(
              child: EmptyWidget(
                  lottiUrl:
                      "https://assets8.lottiefiles.com/packages/lf20_xbf1be8x.json"),
            )
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 10,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         title: Text("$index"),
            //       );
            //     },
            //   ),
            // )
          ],
        ));
  }

  ListStickyItem getBasedOnYourSearchListItem(BuildContext context) {
    return ListStickyItem(
        groupItem: ListStickyGroupItem(
            groupName: AppLocalizations.of(context)!.suggestionList,
            icon: Icons.saved_search_outlined),
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
                          return Chip(
                            deleteIcon: Icon(Icons.done),
                            label: Text(item),
                            onDeleted: () {
                              _controller.text = item;
                              onSearchTextChanged(item);
                            },
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

  ListStickyItem getSuggestionListItem(BuildContext context) {
    return ListStickyItem(
        groupItem: ListStickyGroupItem(
            groupName: AppLocalizations.of(context)!.suggestionList,
            icon: Icons.saved_search_outlined),
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
                          return Chip(
                            deleteIcon: Icon(Icons.done),
                            label: Text(item),
                            onDeleted: () {
                              _controller.text = item;
                              onSearchTextChanged(item);
                            },
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
    _debouncer.run(() async {
      await Configurations.saveQueryHistory(
          drawerViewAbstractObsever.getObject, value);
      setState(() {});
    });
  }
}
