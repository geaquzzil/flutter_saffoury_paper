import 'package:dual_screen/dual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_view_controller/configrations.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/models/auto_rest.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/cards/card_background_with_title.dart';
import 'package:flutter_view_controller/new_components/cards/filled_card.dart';
import 'package:flutter_view_controller/new_components/cart/cart_icon.dart';
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
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_search_api.dart';
import 'package:flutter_view_controller/providers/auth_provider.dart';
import 'package:flutter_view_controller/providers/drawer/drawer_controler.dart';

import 'package:flutter_view_controller/size_config.dart';
import 'package:flutter_view_controller/utils/debouncer.dart';
import 'package:flutter_view_controller/utils/dialogs.dart';
import 'package:nil/nil.dart';
import 'package:provider/provider.dart';

import '../lists/list_api_master.dart';

class SearchPage extends StatefulWidget {
  String? tableName;
  ViewAbstract? viewAbstract;
  SearchPage({super.key, required this.viewAbstract, this.tableName});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  ValueNotifier<String> _notiferSearch = ValueNotifier<String>("");
  Widget? startPane;
  Widget? searchPane;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  late ViewAbstract viewAbstract;
  @override
  void initState() {
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else {
      viewAbstract =
          context.read<AuthProvider>().getNewInstance(widget.tableName!)!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    if (widget.viewAbstract != null) {
      viewAbstract = widget.viewAbstract!;
    } else {
      viewAbstract =
          context.read<AuthProvider>().getNewInstance(widget.tableName!)!;
    }
    super.didUpdateWidget(oldWidget);
  }

  void callDebouncer(String query) {
    _debouncer.run(() async {
      _notiferSearch.value = query;
    });
  }

  Widget _buildSearchBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: ListTile(
          // tileColor: Colors.transparent,
          leading: const Icon(Icons.search),
          title: TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: (value) async {
              debugPrint("onSubmitted $value");
              await Configurations.saveQueryHistory(viewAbstract, value);
              callDebouncer(value);
            },
            controller: _controller,
            decoration: InputDecoration(
                fillColor: Colors.transparent,
                hintText: AppLocalizations.of(context)?.search,
                border: InputBorder.none),
          ),
          trailing: CartIconWidget(
            returnNillIfZero: true,
            onPressed: () {
              debugPrint("onPressed cart");
            },
          )),
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
    startPane ??= SizeConfig.isLargeScreenGeneral(context)
        ? getFirstPane(context)
        : getFirstPaneMobile(context);
    searchPane ??= getSearchList();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: getAppBar(context),
        body: TowPaneExt(
          startPane: startPane!,
          endPane: searchPane,
        ));
  }

  Widget getFirstPane(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (SizeConfig.isLargeScreenGeneral(context))
          SliverToBoxAdapter(
            child: Hero(
                tag: "/search", child: Card(child: _buildSearchBox(context))),
          ),
        // SliverToBoxAdapter(
        //   child: BaseFilterableMainWidget(
        //     setHeaderTitle: false,
        //     useDraggableWidget: false,
        //   ),
        // ),
        SliverToBoxAdapter(
          child: CardBackgroundWithTitle(
              useHorizontalPadding: false,
              title: AppLocalizations.of(context)!.suggestionList,
              leading: Icons.info_outline,
              child: _getSuggestionWidget()),
        ),

        SliverToBoxAdapter(
          child: CardBackgroundWithTitle(
              useHorizontalPadding: false,
              title: AppLocalizations.of(context)!.basedOnYourLastSearch,
              leading: Icons.search,
              child: _getBasedOnSearchWidget()),
        ),
        if (!SizeConfig.isLargeScreenGeneral(context))
          SliverFillRemaining(
            child: getEmptyWidget(),
          )
      ],
    );
  }

  Widget getFirstPaneMobile(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _notiferSearch,
      builder: (context, value, child) => value.isEmpty
          ? getFirstPane(context)
          : SliverSearchApi(viewAbstract: viewAbstract, searchQuery: value),
    );
  }

  Widget? getSearchList() {
    if (!SizeConfig.isLargeScreenGeneral(context)) return null;
    return ValueListenableBuilder<String>(
      valueListenable: _notiferSearch,
      builder: (context, value, child) =>
          SliverSearchApi(viewAbstract: viewAbstract, searchQuery: value),
    );
  }

  AppBar? getAppBar(BuildContext context) {
    bool isLargeScree = SizeConfig.isLargeScreenGeneral(context);
    return AppBar(
      title: isLargeScree ? Text(AppLocalizations.of(context)!.search) : null,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: isLargeScree ? true : false,
      surfaceTintColor: isLargeScree ? null : Colors.transparent,
      flexibleSpace: isLargeScree ? null : _getFlexibleSpace(context),
    );
  }

  Hero _getFlexibleSpace(BuildContext context) {
    return Hero(
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
        ));
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
        itemBuilder: (context) => _getBasedOnSearchWidget());
  }

  FutureBuilder<List<String>> _getBasedOnSearchWidget() {
    return FutureBuilder<List<String>>(
      future: Configurations.loadListQuery(viewAbstract),
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
                          obj: getNewInstance()..setCustomMapAsSearchable(e),
                          key: viewAbstract.getListableKeyWithoutCustomMap()))
                      .toList()));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  ViewAbstract getNewInstance() {
    return viewAbstract.getSelfNewInstance();
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
        itemBuilder: (context) => _getSuggestionWidget());
  }

  FutureBuilder<List<String>> _getSuggestionWidget() {
    return FutureBuilder<List<String>>(
      future: Configurations.loadListQuery(viewAbstract),
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
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    surfaceTintColor:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                    avatar: Icon(Icons.search),
                    onPressed: () {
                      _controller.text = item;
                      callDebouncer(item);
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
    );
  }

  Widget getBackFloatingActionButton(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        child: Icon(Icons.arrow_back),
        onPressed: () => {Navigator.pop(context)});
  }

  Future<void> onSearchTextChanged(String value) async {
    if (value.isEmpty) return;
  }
}
