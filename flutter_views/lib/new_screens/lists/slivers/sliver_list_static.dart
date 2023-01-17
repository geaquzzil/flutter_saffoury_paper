import 'package:flutter/material.dart';
import 'package:flutter_view_controller/constants.dart';
import 'package:flutter_view_controller/customs_widget/sliver_delegates.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/list_card_item.dart';
import 'package:flutter_view_controller/new_screens/lists/components/search_componenets_editable.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_master.dart';

class SliverListStatic extends SliverMaster {
  List<ViewAbstract> list;
  SliverListStatic({
    super.key,
    required this.list,
  }) : super(
            title: "",
            buildAppBar: false,
            buildFabIfMobile: false,
            buildFilterableView: false,
            buildHeaderAsQrCodeReader: false,
            buildSearchWidget: true,
            buildToggleView: false);

  @override
  State<SliverListStatic> createState() => SliverListStaticState();
}

class SliverListStaticState extends SliverMasterState<SliverListStatic> {
  ValueNotifier<String> onSearch = ValueNotifier<String>('');
  @override
  Widget onBuildSearchWidget() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegatePreferedSize(
          child: PreferredSize(
        preferredSize: const Size.fromHeight(kDefaultSearchHeight),
        child: SearchWidgetComponentEditable(
          notiferSearch: onSearch,
          trailingIsCart: false,
        ),
      )),
    );
  }

  @override
  Widget onBuildSliverList() {
    if (widget.list.isEmpty) {
      return getEmptyWidget();
    }
    return ValueListenableBuilder<String>(
      valueListenable: onSearch,
      builder: (context, value, child) {
        if (value == '') {
          return SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => getListItem(widget.list[index]),
                  childCount: widget.list.length));
        }
        return FutureBuilder<List<ViewAbstract>>(
          future: getSearchedList(value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.isEmpty) {
                return getEmptyWidget();
              } else {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => getListItem(widget.list[index]),
                        childCount: widget.list.length));
              }
            }
            return getShimmerLoading();
          },
        );
      },
    );
  }

  Future<List<ViewAbstract>> getSearchedList(String searchQuery) async {
    return widget.list
        .where((element) => element
            .toStringValues()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  Widget getListItem(ViewAbstract item) {
    return ListCardItem(object: item);
  }
}
