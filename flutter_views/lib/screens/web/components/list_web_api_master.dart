import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_view_controller/encyptions/compressions.dart';
import 'package:flutter_view_controller/models/view_abstract.dart';
import 'package:flutter_view_controller/new_components/lists/horizontal_list_card_item_shimmer.dart';
import 'package:flutter_view_controller/new_screens/home/components/empty_widget.dart';
import 'package:flutter_view_controller/providers/actions/list_multi_key_provider.dart';
import 'package:flutter_view_controller/providers/filterables/filterable_provider.dart';
import 'package:flutter_view_controller/size_config.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ListWebApiMaster extends StatelessWidget {
  late ListMultiKeyProvider _listProvider;

  final String? searchQuery;
  final String? customFilter;
  Map<String, FilterableProviderHelper>? customFilterChecker;
  ViewAbstract viewAbstract;
  ValueNotifier<bool>? valueNotifierGrid;
  Widget Function(BuildContext context, List<ViewAbstract> list, int count,
      bool isLoading) onLoad;
  int? customPage;
  int? customCount;

  ListMultiKeyProvider get getlistProvider => _listProvider;
  ListWebApiMaster(
      {super.key,
      required this.viewAbstract,
      required this.onLoad,
      this.valueNotifierGrid,
      this.searchQuery,
      this.customPage,
      this.customCount,
      this.customFilter});
  String findCustomKey() {
    String key = viewAbstract.getListableKey();
    return "$key${searchQuery == null ? "" : searchQuery!}$customCount$customPage";
  }

  void init(BuildContext context) {
    if (customFilter != null) {
      Map<String, dynamic> map =
          Compression.uncompress(customFilter!) as Map<String, dynamic>;

      Map<String, FilterableProviderHelper> jsonMap = {};
      for (var element in map.entries) {
        jsonMap[element.key] = FilterableProviderHelper.fromJson(element.value);
      }
      customFilterChecker = jsonMap;
      // onFilterable.value = jsonMap;
      // debugPrint("onFilterable ${onFilterable.value}");
    } else {
      customFilterChecker = null;
    }
    valueNotifierGrid ??= ValueNotifier<bool>(false);
    _listProvider = Provider.of<ListMultiKeyProvider>(context, listen: false);
    fetshListWidgetBinding(context);
  }

  void fetshList(BuildContext context) {
    String customKey = findCustomKey();
    if (_listProvider.getCount(customKey) == 0) {
      fetshListNotCheckingZero(context);
    }
  }

  void fetshListNotCheckingZero(BuildContext context) {
    String customKey = findCustomKey();
    if (customFilterChecker != null) {
      viewAbstract.setFilterableMap(customFilterChecker!);
      customKey = findCustomKey();
      _listProvider.fetchList(customKey, viewAbstract,
          customPage: customPage, customCount: customCount);
    } else if (searchQuery == null) {
      _listProvider.fetchList(customKey, viewAbstract,
          customPage: customPage, customCount: customCount);
    } else {
      _listProvider.fetchListSearch(customKey, viewAbstract, searchQuery!);
    }
  }

  Widget getShimmerLoading(BuildContext context) {
    return ResponsiveGridList(
        horizontalGridSpacing: 50, // Horizontal space between grid items
        verticalGridSpacing: 50, // Vertical space between grid items
        horizontalGridMargin: 50, // Horizontal space around the grid
        verticalGridMargin: 50, // Vertical space around the grid
        minItemsPerRow:
            2, // The minimum items to show in a single row. Takes precedence over minItemWidth
        maxItemsPerRow:
            4, // The maximum items to show in a single row. Can be useful on large screens
        // sliverChildBuilderDelegateOptions: SliverChildBuilderDelegateOptions(),
        minItemWidth: 180,
        children: [
          ...List.generate(customCount ?? (5 + Random().nextInt(10 - 5)),
              (index) => ListHorizontalItemShimmer())
        ]);
  }

  Widget getEmptyWidget(BuildContext context, {bool isError = false}) {
    return Center(
      child: EmptyWidget(
          expand: false,
          onSubtitleClicked: isError
              ? () {
                  fetshList(context);
                }
              : null,
          lottiUrl:
              "https://assets7.lottiefiles.com/packages/lf20_0s6tfbuc.json",
          title: isError
              ? AppLocalizations.of(context)!.cantConnect
              : AppLocalizations.of(context)!.noItems,
          subtitle: isError
              ? AppLocalizations.of(context)!.cantConnectConnectToRetry
              : AppLocalizations.of(context)!.no_content),
    );
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return Selector<ListMultiKeyProvider, Tuple3<bool, int, bool>>(
      builder: (context, value, child) {
        // List<Widget> widgets;
        debugPrint("SliverApiMaster building widget: ${findCustomKey()}");
        bool isLoading = value.item1;
        int count = value.item2;
        bool isError = value.item3;

        if (isLoading) {
          if (count == 0) {
            if (valueNotifierGrid!.value) {
              return getShimmerLoading(context);
            } else {
              return getShimmerLoadingList();
            }
          }
        } else {
          if (count == 0 || isError) {
            return getEmptyWidget(context, isError: isError);
          }
        }
        return onLoad.call(
            context, getlistProvider.getList(findCustomKey()), count, isError);
      },
      selector: (p0, p1) => Tuple3(p1.isLoading(findCustomKey()),
          p1.getCount(findCustomKey()), p1.isHasError(findCustomKey())),
    );
  }

  Widget getShimmerLoadingList() {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          Color(0xFFD8E3E7),
          Color(0xFFC8D5DA),
          Color(0xFFD8E3E7),
        ],
        stops: [
          0.1,
          0.5,
          0.9,
        ],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
          // Color(0xFF242424),
          // Color(0xFF2B2B2B),
          // Color(0xFF242424),
          // Color(0xFF222222),
        ],
        stops: [
          0.0,
          0.2,
          0.5,
          0.8,
          1,
        ],
        // begin: Alignment(-2.4, -0.2),
        // end: Alignment(2.4, 0.2),
        // tileMode: TileMode.clamp,
      ),
      child: SkeletonListView(
        itemCount: viewAbstract.getPageItemCount,
      ),
    );
  }

  void fetshListWidgetBinding(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetshList(context);
    });
  }
}
