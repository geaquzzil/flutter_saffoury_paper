import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/new_screens/lists/slivers/sliver_api_master.dart';


///this widget use if the search text edit controller is seperated from the widget 
class SliverSearchApi extends SliverApiMaster {
  String searchQuery;
  SliverSearchApi(
      {super.key, required super.viewAbstract, required this.searchQuery})
      : super(
            buildAppBar: false,
            buildFabIfMobile: false,
            buildSearchWidget: false,
            buildFilterableView: true,
            fetshListAsSearch: true);

  @override
  State<SliverSearchApi> createState() => _SliverSearchApiState();
}

class _SliverSearchApiState extends SliverApiMasterState<SliverSearchApi> {
  late String searchQuery;

  @override
  void initState() {
    searchQuery = widget.searchQuery;
    super.initState();
  }

  @override
  void fetshListWidgetBinding() {
    if (searchQuery.isEmpty) return;
    super.fetshListWidgetBinding();
  }

  @override
  String findCustomKey() {
    return super.findCustomKey() + searchQuery;
  }

  @override
  Widget getEmptyWidget({bool isError = false}) {
    if (searchQuery.isEmpty) {
      return SliverFillRemaining(
        child: EmptyWidget(
            lottiUrl:
                "https://assets1.lottiefiles.com/private_files/lf30_jo7huq2d.json"),
      );
    }
    return super.getEmptyWidget(isError: isError);
  }

  @override
  void fetshList() {
    listProvider.fetchListSearch(findCustomKey(), viewAbstract, searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return CustomScrollView(slivers: [getEmptyWidget(isError: false)]);
    }
    return super.build(context);
  }

  @override
  void didUpdateWidget(covariant SliverSearchApi oldWidget) {
    if (searchQuery != widget.searchQuery) {
      searchQuery = widget.searchQuery;
      debugPrint("SliverSearchApi.didUpdateWidget $searchQuery");
      fetshListWidgetBinding();
      // setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }
}
